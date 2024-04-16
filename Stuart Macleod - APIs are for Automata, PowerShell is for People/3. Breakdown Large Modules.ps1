#---- Tip 3 - Breakdown Large Modules

# Installation
Install-Module DemoGrandparent -Repository local
Get-Module Demo* -ListAvailable

Get-Module Demo*
Import-Module DemoGrandparent
Get-Module Demo*

#---- Cleanup
Remove-Module DemoGrandparent
Remove-Module DemoParent
Remove-Module DemoChild
Uninstall-Module DemoGrandparent
Uninstall-Module DemoParent
Uninstall-Module DemoChild
Clear-Host