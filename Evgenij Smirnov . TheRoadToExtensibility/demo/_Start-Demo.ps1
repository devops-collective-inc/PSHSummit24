$demo_layout = [ordered]@{
    'Warming Up' = @("00-00-check-ffl.ps1","00-01-bad-naming.ps1")
    'Input' = @("01-00-do-stuff-red.ps1","01-01-do-stuff-green.ps1","01-02-do-stuff-rightclick.ps1","01-10-static-mode.ps1","01-11-dynamic-mode.ps1","01-12-dynamic-multimode.ps1")
    'Coding Techniques' = @("02-00-master-functions.ps1")
    'Error Handling' = @("03-00-red-alert.ps1","CompanyVM.psm1")
}
if ($psise.CurrentVisibleVerticalTool.IsVisible) {
    $psise.CurrentVisibleVerticalTool.IsVisible = $false
}
Set-Location $PSScriptRoot
$current_tab = $psise.CurrentPowerShellTab
$current_tab.DisplayName = "Start-Demo"
foreach ($demo in $demo_layout.GetEnumerator()) {
    $demo_tab = $psise.PowerShellTabs.Add()
    $demo_tab.DisplayName = $demo.Name    
    foreach ($file in $demo.Value) {
        $demo_file = $demo_tab.Files.Add((Join-Path -Path $PSScriptRoot -ChildPath $file))
        $demo_file.Editor.EnsureVisible(1)
        $demo_file.Editor.Focus()
        $demo_file.Editor.ToggleOutliningExpansion()
    }
    $demo_tab.Files.SetSelectedFile($demo_tab.Files[0])
}
#Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "http://devws/Home/Index"
$psise.PowerShellTabs.SetSelectedPowerShellTab($current_tab)
