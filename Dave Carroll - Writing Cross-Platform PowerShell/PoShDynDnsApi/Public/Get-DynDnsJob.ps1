function Get-DynDnsJob {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$JobId
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $JobData = Invoke-DynDnsRequest -UriPath "/REST/Job/$JobId"
    Write-DynDnsOutput -DynDnsResponse $JobData
}