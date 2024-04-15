function Remove-DynDnsRecord {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [DynDnsRecord[]]$DynDnsRecord
    )

    begin {

        if (-Not (Test-DynDnsSession)) {
            return
        }

    }

    process {

        foreach ($Record in $DynDnsRecord) {

            $Fqdn = $Record.RawData.fqdn
            $Zone = $Record.RawData.zone
            $RecordType = $Record.RawData.record_type
            $RecordId = $Record.RecordId

            $Record

            if ($PSCmdlet.ShouldProcess("$Fqdn","Delete DNS $RecordType record")) {
                $RemoveRedirect = Invoke-DynDnsRequest -UriPath "/REST/$($RecordType)Record/$Zone/$Fqdn/$RecordId" -Method Delete
                Write-DynDnsOutput -DynDnsResponse $RemoveRedirect
            } else {
                Write-Verbose 'Whatif : Removed  DNS record'
            }
        }
    }

    end {

    }

}