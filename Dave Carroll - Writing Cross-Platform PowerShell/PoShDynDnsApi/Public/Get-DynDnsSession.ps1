function Get-DynDnsSession {
    [CmdLetBinding()]
    param()

    $DynDnsSession | ConvertTo-Json | ConvertFrom-Json
}