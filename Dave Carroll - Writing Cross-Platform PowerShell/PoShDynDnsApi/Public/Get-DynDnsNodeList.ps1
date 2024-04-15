function Get-DynDnsNodeList {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [string]$Node
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($Node) {
        if ($Node -match $Zone ) {
            $Fqdn = $Node
        } else {
            $Fqdn = $Node + '.' + $Zone
        }
        $UriPath = "/REST/NodeList/$Zone/$Fqdn/"
    } else {
        $UriPath = "/REST/NodeList/$Zone/"
    }

    $NodeList = Invoke-DynDnsRequest -UriPath $UriPath
    Write-DynDnsOutput -DynDnsResponse $NodeList
}