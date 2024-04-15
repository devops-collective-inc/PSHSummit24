function Get-DynDnsZoneChanges {
    [CmdLetBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseSingularNouns','Retrieves all zone changes')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $ZoneChanges = Invoke-DynDnsRequest -UriPath "/REST/ZoneChanges/$Zone"
    Write-DynDnsOutput -DynDnsResponse $ZoneChanges
}