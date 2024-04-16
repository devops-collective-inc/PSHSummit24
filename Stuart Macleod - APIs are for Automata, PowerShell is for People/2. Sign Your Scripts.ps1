#---- Tip 2 - Sign Your Scripts
Set-ExecutionPolicy -Scope CurrentUser AllSigned
Import-Module .\Modules\DemoUnSigned

$cert = Get-ChildItem -Path Cert:\CurrentUser\TrustedPublisher -CodeSigningCert
Get-ChildItem .\Modules\DemoSigned\ | ForEach-Object { Set-AuthenticodeSignature -Certificate $Cert -FilePath $_ }

Import-Module .\Modules\DemoSigned

#---- Cleanup
Set-ExecutionPolicy -Scope CurrentUser Unrestricted
Remove-Module Demo*
Clear-Host