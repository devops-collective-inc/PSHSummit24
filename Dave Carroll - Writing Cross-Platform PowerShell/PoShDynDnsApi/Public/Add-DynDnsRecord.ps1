function Add-DynDnsRecord {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [string]$Node,
        [Parameter(Mandatory=$true)]
        [DynDnsRecord]$DynDnsRecord
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($DynDnsRecord.record_type -eq 'SOA') {
        Write-Warning -Message 'You cannot add a new SOA record with this command. Please use Update-DynDnsRecord to update the ResponsiblePerson, SerialStyle, or TTL.'
        return
    }

    if ($Node) {
        if ($Node -match $Zone ) {
            $Fqdn = $Node
        } else {
            $Fqdn = $Node + '.' + $Zone
        }
    } else {
        $Fqdn = $Zone
    }

    $UriPath = "/REST/$($DynDnsRecord.Type)Record/$Zone/$Fqdn/"

    $DynDnsRecord.RawData.Remove('record_type')
    $JsonBody = $DynDnsRecord.RawData | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess("$($DynDnsRecord.Type) - $Fqdn","Adding DNS record")) {
        $NewHttpRedirect = Invoke-DynDnsRequest -UriPath $UriPath -Method Post -Body $JsonBody
        Write-DynDnsOutput -DynDnsResponse $NewHttpRedirect
    } else {
        Write-Verbose 'Whatif : Added DNS record'
    }
}