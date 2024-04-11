
function Remove-DynDnsZone {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    Write-Warning -Message 'Continuing will immediately delete the zone.'

    if ($PSCmdlet.ShouldProcess("$Zone",'Delete DNS zone and all its records')) {
        $DeleteZone = Invoke-DynDnsRequest -UriPath "/REST/Zone/$Zone" -Method Delete
        Write-DynDnsOutput -DynDnsResponse $DeleteZone
    } else {
        Write-Verbose 'Whatif : Deleted DNS zone and all its records'
    }
}