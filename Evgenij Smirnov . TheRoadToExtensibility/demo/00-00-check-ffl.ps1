<#
    This check will start failing come 2025

    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region check if AD FFL is 2012R2 or higher
if (([ADSI]'LDAP://rootDSE').forestFunctionality[0] -gt 5) {
    Write-Host 'Modern!'
} else {
    Write-Host 'Old!'
}
#endregion