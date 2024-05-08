# ----------------------------------------
# PSReadLine
# ----------------------------------------
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

Install-PSResource -Name CompletionPredictor
Install-PSResource -Name Az.Tools.Predictor
Import-Module -Name CompletionPredictor
Import-Module -Name Az.Tools.predictor

# History Handler
$ScriptBlock = {
    Param([string]$line)

    if ($line -match "key") {
        return $false
    } else {
        return $true
    }
}

Set-PSReadLineOption -AddToHistoryHandler $ScriptBlock

# ----------------------------------------
# Feedback Providers
# ----------------------------------------
Enable-ExperimentalFeature PSFeedbackProvider

Install-PSResource -Name Microsoft.PowerShell.PSAdapter

$env:Path += "/Users/stevenbucher/Library/CloudStorage/OneDrive-Microsoft/Documents/PSSummitNA2024"


