function Connect-DynDnsSession {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory = $true, HelpMessage = 'The Dyn API user (not DynID)')]
        [Alias('ApiUserName','UserName')]
        [string]$User,
        [Parameter(Mandatory = $true, HelpMessage = "The customer name for the Dyn API user")]
        [Alias('CustomerName')]
        [string]$Customer,
        [Parameter(Mandatory = $true, HelpMessage = 'The Dyn API user password')]
        [Alias('pwd','pass')]
        [SecureString]$Password,
        [switch]$Force
    )

    if ($DynDnsSession.AuthToken) {
        Write-Verbose -Message 'Existing authentication token found.'
    }
    if (Test-DynDnsSession -WarningAction SilentlyContinue) {
        if ($Force) {
            $Disconnect = Disconnect-DynDnsSession
            Write-DynDnsOutput -DynDnsResponse $Disconnect
            if ($Disconnect.Data.status -eq 'failure') {
                return
            }
        } else {
            Write-Warning -Message 'There is a valid active session. Use the -Force parameter to logoff and create a new session.'
            Write-Warning -Message 'All unpublished changes will be discarded should you proceed with creating a new session.'
            return
        }
    } elseif ($DynDnsSession.AuthToken) {
        Write-Verbose -Message 'There is an expired authentication token which will be overridden upon successful creationn of a new session.'
    }

    $JsonBody = @{
        customer_name = "$Customer"
        user_name = "$User"
        password = ([pscredential]::new('user',$Password).GetNetworkCredential().Password)
    }  | ConvertTo-Json

    $DynDnsSession.User = $User
    $DynDnsSession.Customer = $Customer

    $Session = Invoke-DynDnsRequest -SessionAction 'Connect' -Body $JsonBody
    if ($Session.Data.status -eq 'success') {
        $DynDnsSession.AuthToken = $Session.Data.data.token
        $DynDnsSession.ApiVersion = $Session.Data.data.version
        $DynDnsSession.StartTime = [System.DateTime]::Now
        $DynDnsSession.ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
        Write-DynDnsOutput -DynDnsResponse $Session
    } else {
        Write-DynDnsOutput -DynDnsResponse $Session
    }
}