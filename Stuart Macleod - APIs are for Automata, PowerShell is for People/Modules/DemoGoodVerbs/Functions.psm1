function Invoke-Thing {
    [CmdletBinding()]
    [Alias('Do-Thing')]
    Param()
    Write-Host "Function called: $($MyInvocation.Line)"
}