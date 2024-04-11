function Get-DynDnsTask {
    [CmdLetBinding()]
    param(
        [int]$TaskId
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($TaskId) {
        $UriPath = "/REST/Task/$($TaskId.ToString())"
    } else {
        $UriPath = "/REST/Task/"
    }

    $TaskData = Invoke-DynDnsRequest -UriPath $UriPath
    Write-DynDnsOutput -DynDnsResponse $TaskData
}