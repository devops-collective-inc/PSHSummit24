<#
    This script shows some examples of 
    extensibility gone bad in naming
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region runme
Set-Location D:\Demo
Clear-Host
break
#endregion
#region compare name and parameters
.\00-naming\Inventory-ThisMachineWMI.ps1 -ComputerName a -Protocol 
#endregion
#region compare name and actions
.\00-naming\Report-DatabaseUsage.ps1 -DatabaseName ABC
#endregion
#region module provides unexpected methods
Get-Module Inv* -ListAvailable
Get-Command -Module Inventory.TheWorld
#endregion