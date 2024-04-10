<#
    
    This is your typical extensibility victim:
    
    - script name suggests it was initially made as a one-trick-pony
    - parameters tell a different story...

#>
#region head
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [ValidatePattern('^[a-zA-z][a-zA-z0-9\-]{0,15}$')]
    [string[]]$ComputerName = 'localhost',
    [Parameter(Mandatory=$false)]
    [ValidateSet('WMI','WinRM','SSH')]
    [string]$Protocol = 'WMI'
)
#endregion
#region body
if ($ComputerName.Count -gt 1) { $multiS = 's' } else { $multiS = '' }
Write-Host ('Inventorying {0} computer{1} using {2}' -f $ComputerName.Count, $multiS, $Protocol)
#endregion