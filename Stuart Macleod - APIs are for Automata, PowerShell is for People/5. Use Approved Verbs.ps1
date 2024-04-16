#---- Tip 5 - Use Approved Verbs

Import-Module ./Modules/DemoBadVerbs
Do-Thing
Invoke-Thing

Remove-Module DemoBadVerbs
Clear-Host

Import-Module ./Modules/DemoGoodVerbs
Do-Thing
Invoke-Thing

#---- Cleanup
Remove-Module Demo*
Clear-Host