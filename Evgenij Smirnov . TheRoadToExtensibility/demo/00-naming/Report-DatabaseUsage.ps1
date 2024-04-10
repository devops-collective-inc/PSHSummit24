<#
    
    This is your typical extensibility victim:
    
    - script name suggests only a reporting capability
    - parameters tell a different story...

#>
#region head
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string[]]$DatabaseName,
    [Parameter(Mandatory=$false)]
    [switch]$Optimize,
    [Parameter(Mandatory=$false)]
    [switch]$Drop
)
#endregion
#region body
foreach ($db in $DatabaseName) {
    if (-not ($Optimize -or $Drop)) { 
        Write-Host ('Table usage report for database [{0}]' -f $db) -ForegroundColor Green
        Write-Host ('tblAdminAccounts - {0} MB' -f (Get-Random -Minimum 1 -Maximum 20)) -ForegroundColor Green
        Write-Host ('tblUserAccounts - {0} MB' -f (Get-Random -Minimum 36 -Maximum 2045)) -ForegroundColor Green
        Write-Host ' '
    } elseif ($Optimize) {
        Write-Host ('Optimizing database [{0}]' -f $db) -ForegroundColor Yellow
    } elseif ($Drop) {
        Write-Host ('Dropping database [{0}]' -f $db) -ForegroundColor Red
    }
}
#endregion