'-' * (Get-Host).UI.RawUI.MaxWindowSize.Width
'PowerShell profile script: $PROFILE.CurrentUserAllHosts - {0}' -f $PROFILE.CurrentUserAllHosts
'Calling MultiPlatformProfile.ps1 from $PROFILE.CurrentUserAllHosts'
'-' * (Get-Host).UI.RawUI.MaxWindowSize.Width

''
& '/mnt/c/Users/dave/GoogleDrive/Preso/2024/Writing Cross-Platform PowerShell/MultiPlatformProfile.ps1'