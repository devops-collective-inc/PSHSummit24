#region Path Separator and Directory Separator Character

# Windows Path Separator
$env:PSModulePath -split ';'

# Linux Path Separator
$env:PSModulePath -split ':'

# Cross-Platform Path Separator Conditional, attempt 1
if ($IsWindows) {
    $PathSeparator = ';'
} else {
    $PathSeparator = ':'
}
$env:PSModulePath -split $PathSeparator

# Cross-Platform Path Separator Conditional, attempt 2
$PathSeparator = if ($IsLinux -or $IsMacOS) { ':' } else { ';' }
$env:PSModulePath -split $PathSeparator

# Cross-Platform Path Separator
$env:PSModulePath -split [System.IO.Path]::PathSeparator

# Cross-Platform Directory Separator Character
[System.IO.Path]::DirectorySeparatorChar
[System.IO.Path]::AltDirectorySeparatorChar
[System.IO.Path]::VolumeSeparatorChar
#endregion

#region Special Folders

# Windows Environment Variables for Special Folders
$env:TEMP
$env:TMP
$env:USERPROFILE
$env:ALLUSERSPROFILE
$env:APPDATA
$HOME

# Linux Environment Variables for Special Folders
$env:HOME
$HOME

# Cross-Platform Variables for Special Folders and System Information
$UserProfile = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)

[System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
[System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::LocalApplicationData)

[System.IO.Path]::GetTempPath()
[System.IO.Path]::GetTempFileName()
[System.IO.Path]::GetRandomFileName()

[System.Environment]::OSVersion
[System.Environment]::MachineName
#endregion

#region Environment Variables
Get-ChildItem -Path Env: | Format-Table -AutoSize

# Set a variable
$env:PSHSUMMIT_DEMO_1 = 'PowerShell Summit 2024 Demo - $PROFILE Environment Variables'

# For the Current User
[System.Environment]::SetEnvironmentVariable('PSHSUMMIT_DEMO_2', 'PowerShell Summit 2024 Demo 2 - User Environment Variables', [System.EnvironmentVariableTarget]::User)

# For the Machine (requires elevated permissions)
[System.Environment]::SetEnvironmentVariable('PSHSUMMIT_DEMO_3', 'PowerShell Summit 2024 Demo 3 - Machine Environment Variables', [System.EnvironmentVariableTarget]::Machine)

#endregion
