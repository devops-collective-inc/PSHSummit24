function Disconnect-DynDnsSession {
    [CmdLetBinding()]
    param()

    $Session = Invoke-DynDnsRequest -SessionAction 'Disconnect'
    if ($Session.Data.status -eq 'success') {
        Write-DynDnsOutput -DynDnsResponse $Session
    } else {
        Write-DynDnsOutput -DynDnsResponse $Session -WarningAction Continue
    }
    $DynDnsSession.AuthToken = $null
    $DynDnsSession.User = $null
    $DynDnsSession.Customer = $null
    $DynDnsSession.StartTime = $null
    $DynDnsSession.ElapsedTime = $null
    $DynDnsSession.RefreshTime = $null

}