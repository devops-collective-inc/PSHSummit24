function Get-DynDnsHttpRedirect {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [string]$Node
    )

    if ($Node) {
        if ($Node -match $Zone ) {
            $Fqdn = $Node
        } else {
            $Fqdn = $Node + '.' + $Zone
        }
        $Uri = "/REST/HTTPRedirect/$Zone/$Fqdn"
    } else {
        $Uri = "/REST/HTTPRedirect/$Zone"
    }

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $HttpRedirects = Invoke-DynDnsRequest -UriPath $Uri
    Write-DynDnsOutput -DynDnsResponse $HttpRedirects -SkipSuccess
    if ($HttpRedirects.Data.status -eq 'failure') {
        return
    }

    if ($Node) {
        Write-DynDnsOutput -DynDnsResponse $HttpRedirects
    } else {
        foreach ($UriPath in $HttpRedirects.Data.data) {
            $RedirectData = Invoke-DynDnsRequest -UriPath $UriPath
            Write-DynDnsOutput -DynDnsResponse $RedirectData
        }
    }
}