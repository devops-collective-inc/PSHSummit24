function Get-DynDnsUser {
    [CmdLetBinding()]
    param(
        [Alias('ApiUserName','UserName')]
        [string]$User
    )

    if ($User) {
        $UriPath = "/REST/User/$User"
    } else {
        $UriPath = "/REST/User/"
    }

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $Users = Invoke-DynDnsRequest -UriPath $UriPath
    Write-DynDnsOutput -DynDnsResponse $Users -SkipSuccess
    if ($Users.Data.status -eq 'failure') {
        return
    }

    if ($User) {
        Write-DynDnsOutput -DynDnsResponse $Users
    } else {
        foreach ($UriPath in $Users.Data.data) {
            $UserData = Invoke-DynDnsRequest -UriPath $UriPath
            Write-DynDnsOutput -DynDnsResponse $UserData
        }
    }
}