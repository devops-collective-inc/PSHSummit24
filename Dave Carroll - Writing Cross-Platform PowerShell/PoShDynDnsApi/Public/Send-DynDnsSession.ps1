function Send-DynDnsSession {
    [CmdLetBinding()]
    param()

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $Session = Invoke-DynDnsRequest -SessionAction 'Send'
    Write-DynDnsOutput -DynDnsResponse $Session
    if ($Session.Data.status -eq 'success') {
        $DynDnsSession.RefreshTime = [System.DateTime]::Now
    }
}