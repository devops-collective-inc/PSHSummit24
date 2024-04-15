#Requires -Module Pode
#Requires -Module Pode.Web
#Requires -Module AzBobbyTables

$storagePath = ".\local.settings.psd1"
if (test-path $storagePath) {
    Import-PowerShellDataFile $storagePath |
    ForEach-Object GetEnumerator |
    ForEach-Object { [System.Environment]::SetEnvironmentVariable($_.name, $_.value); $_.name }
}

Import-Module Pode.Web
Start-PodeServer {
    . .\sessions.ps1
    . .\base.ps1
    . .\authschemes.ps1
    . .\routes.ps1
    . .\pages.ps1
    . .\register.ps1

} -Threads 3
