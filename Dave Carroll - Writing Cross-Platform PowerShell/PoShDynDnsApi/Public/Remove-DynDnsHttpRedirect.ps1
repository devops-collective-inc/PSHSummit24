function Remove-DynDnsHttpRedirect {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [DynDnsHttpRedirect[]]$DynDnsHttpRedirect,

        [switch]$PublishWait
    )

    begin {

        if (-Not (Test-DynDnsSession)) {
            return
        }

        if ($PublishWait) {
            $JsonBody = @{
                publish = "N"
            } | ConvertTo-Json

        } else {
            $JsonBody = @{
                publish = "Y"
            } | ConvertTo-Json

            Write-Warning -Message 'This will autopublish the HTTP redirect deletion to the zone.'
        }

    }

    process {

        foreach ($Redirect in $DynDnsHttpRedirect) {

            $Fqdn = $Redirect.RawData.fqdn
            $Zone = $Redirect.RawData.zone
            $Url = $Redirect.RawData.url

            $Redirect

            if ($PSCmdlet.ShouldProcess("$Url",'Delete HTTP redirect')) {
                $RemoveRedirect = Invoke-DynDnsRequest -UriPath "/REST/HTTPRedirect/$Zone/$Fqdn" -Method Delete -Body $JsonBody
                Write-DynDnsOutput -DynDnsResponse $RemoveRedirect
            } else {
                Write-Verbose 'Whatif : Removed HTTP redirect'
            }
        }
    }

    end {

    }

}