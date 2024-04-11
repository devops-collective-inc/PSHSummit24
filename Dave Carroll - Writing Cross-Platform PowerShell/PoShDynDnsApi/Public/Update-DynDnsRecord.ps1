function Update-DynDnsRecord {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [DynDnsRecord]$DynDnsRecord,
        [Parameter(Mandatory=$true)]
        [DynDnsRecord]$UpdatedDynDnsRecord
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($DynDnsRecord.GetType() -ne $UpdatedDynDnsRecord.GetType()) {
        Write-Warning -Message "The original record type does not match the updated record type."
        return
    } else {
        Write-Verbose -Message "The original record type matches the updated record type."
    }

    $Fqdn = $DynDnsRecord.Name
    $Zone = $DynDnsRecord.Zone
    $RecordType = $DynDnsRecord.Type
    $RecordId = $DynDnsRecord.RecordId

    if ($RecordType -eq 'SOA') {
        $Body = $UpdatedDynDnsRecord.RawData | ConvertTo-Json | ConvertFrom-Json
        Add-Member -InputObject $Body -MemberType NoteProperty -Name serial_style -Value $DynDnsRecord.RawData.serial_style -Force
        $JsonBody = $Body | Select-Object * -ExcludeProperty record_type | ConvertTo-Json
    } else {
        $JsonBody = $UpdatedDynDnsRecord.RawData | ConvertTo-Json | ConvertFrom-Json | Select-Object * -ExcludeProperty record_type | ConvertTo-Json
    }

    $UpdatedAttributes = Compare-ObjectProperties -ReferenceObject $DynDnsRecord -DifferenceObject $UpdatedDynDnsRecord | ForEach-Object {
        if ($_.DiffValue.length -gt 0 -and $_.DiffValue -ne 0) { $_ }
    }
    $UpdatedAttributes = $UpdatedAttributes | Select-Object @{label='Attribute';expression={$_.PropertyName}},
        @{label='Original';expression={$_.RefValue}},@{label='Updated';expression={$_.DiffValue}} | Out-String

    $OriginalRecord = "`n" + '-' * 80 + "`n"
    $OriginalRecord += "Original DNS Record:`n"
    $OriginalRecord += ($DynDnsRecord | Out-String).Trim() + "`n`n"
    Write-Verbose -Message $OriginalRecord

    $Updates = "`n" + '-' * 80 + "`n"
    $Updates += "Update DNS Record Attributes::`n"
    $Updates += $UpdatedAttributes.Trim() + "`n"
    $Updates += "`n" + '-' * 80 + "`n"
    Write-Verbose -Message $Updates

    if ($PSCmdlet.ShouldProcess("$Fqdn","Update DNS $RecordType record")) {
        $UpdateDnsRecord = Invoke-DynDnsRequest -UriPath "/REST/$($RecordType)Record/$Zone/$Fqdn/$RecordId" -Method Put -Body $JsonBody
        Write-DynDnsOutput -DynDnsResponse $UpdateDnsRecord
    } else {
        Write-Verbose "Whatif : Updated DNS $RecordType record"
    }
}