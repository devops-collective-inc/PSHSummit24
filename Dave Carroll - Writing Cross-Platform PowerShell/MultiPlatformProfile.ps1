# Multi platform profile script for PowerShell and Windows PowerShell
$Tab = '  '

# Set PowerShell Telemetry OptOut
$env:POWERSHELL_TELEMETRY_OPTOUT = $true

#region Setting Variables Based on Platform
if ($PSVersionTable.PSVersion.Major -lt 6) {
    $WindowsPowerShell = $true
}

if ($IsWindows -or $WindowsPowerShell) {
    if ($PSVersionTable.PSEdition -eq 'Core') {
        'PowerShell on Windows - PSVersion {0}' -f $PSVersionTable.PSVersion
    } else {
        'Windows PowerShell - PSVersion {0}' -f $PSVersionTable.PSVersion
    }
    $global:IsAdmin = [bool](([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))

    $UserProfile = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
    $UserConfig = Join-Path -Path $UserProfile -ChildPath '.config'
    $OhMyPoshConfig = Join-Path -Path $UserConfig -ChildPath 'mytheme.json'
    $OhMyPoshCommand = (Get-Command -Name 'oh-my-posh.exe').Source

    Set-Variable -Name DemoFolder -Value 'C:\Users\dave\GoogleDrive\Preso\2024\Writing Cross-Platform PowerShell' -Scope global
    $PSReadLineHistoryFile = [System.IO.Path]::Combine($DemoFolder,'PSReadLine','PSReadLineHistory.txt')

} elseif ($IsLinux) {
    'PowerShell on Linux - PSVersion {0}' -f $PSVersionTable.PSVersion
    $global:IsAdmin = $false

    $UserConfig = '/mnt/c/Users/dave/.config'
    $OhMyPoshConfig = Join-Path -Path $UserConfig -ChildPath 'mytheme.json'
    $OhMyPoshCommand = (Get-Command -Name 'oh-my-posh').Source

    Set-Variable -Name DemoFolder -Value '/mnt/c/Users/dave/GoogleDrive/Preso/2024/Writing Cross-Platform PowerShell' -Scope global
    $PSReadLineHistoryFile = [System.IO.Path]::Combine($DemoFolder,'PSReadLine','PSReadLineHistory.txt')
}
#endregion

#region Oh My Posh
''
'Oh My Posh:'
if ($OhMyPoshCommand) {
    if (Test-Path -Path $OhMyPoshConfig) {
        $OhMyPoshVersion = (&"$OhMyPoshCommand" --version)
        '{0}Oh My Posh version {1} is installed. Loading custom theme.' -f $Tab,$OhMyPoshVersion
        (@(&"$OhMyPoshCommand" init pwsh --config="$OhMyPoshConfig" --print) -join [System.Environment]::NewLine) | Invoke-Expression
    } else {
        '{0}Oh My Posh configuration file ({1}) not found. Not loading Oh My Posh.' -f $Tab,$OhMyPoshConfig | Write-Warning
    }
}
#endregion

#region PSReadLine
''
'PSReadLine:'
$PSReadLineHistoryPath = Split-Path -Path $PSReadLineHistoryFile -Parent -ErrorAction SilentlyContinue
if (-Not ($PSReadLineHistoryPath)) {
    '{0}Creating PSReadLine history path: {1}' -f $Tab,$PSReadLineHistoryPath
    try {
        New-Item -Path $PSReadLineHistoryPath -ItemType Directory -Force
    }
    catch {
        '{0}Failed to create PSReadLine history path. Error: {1}' -f $Tab,$_
    }
}
$PSReadLineOptions = @{
    HistoryNoDuplicates = $true
    HistorySaveStyle = 'SaveIncrementally'
    HistorySavePath = $PSReadLineHistoryFile
}
try {
    $IsPSReadLineLoaded = Get-Module -Name PSReadLine
    if ($null -ne $IsPSReadLineLoaded) {
        '{0}PSReadLine module version {1} is already loaded.' -f $Tab,$IsPSReadLineLoaded.Version
    } else {
        $IsPSReadLineInstalled = Get-Module -Name PSReadLine -ListAvailable | Sort-Object -Property Version -Descending | Select-Object -First 1
        if ($null -ne $IsPSReadLineInstalled) {
            if ($null -eq $IsPSReadLineLoaded) {
                $ImportPSReadline = Import-Module -Name PSReadLine
                '{0}Imported PSReadLine module version {1}.' -f $Tab,$ImportPSReadline.Version
            }
        } else {
            Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck | Out-Null
            $ImportPSReadline = Import-Module -Name PSReadLine
            '{0}Installed and imported PSReadLine module version {1}.' -f $Tab,$ImportPSReadline.Version
        }
    }
}
catch {
    if ($IsPSReadLineInstalled) {
        '{0}Failed to import PSReadLine module. Error: {1}' -f $Tab,$_
    } else {
        '{0}Failed to install and import PSReadLine module. Error: {1}' -f $Tab,$_
    }
}
try {
    if ($PSVersionTable.PSEdition -eq 'Core') {
        $PSReadLineOptions.Add('PredictionSource','History')
        $PSReadLineOptions.Add('PredictionViewStyle','ListView')
    }
    Set-PSReadLineOption @PSReadLineOptions
    '{0}Set PSReadLine options.' -f $Tab
}
catch {
    'Failed to set PSReadLine options. Error: {0}' -f $_
}
#endregion

Set-Location -Path $DemoFolder
''
