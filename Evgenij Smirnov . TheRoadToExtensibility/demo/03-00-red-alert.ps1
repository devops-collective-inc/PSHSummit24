<#
    Red alert
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region red alert
trap{
    Write-Host 'Red Alert' -ForegroundColor Red
    $redAlert = [PSCustomObject]@{
        'ErrorMessage' = $_.Exception.Message
        'ErrorSource' = $_.Exception.Source
        'StackTrace' =  $_.Exception.StackTrace 
        'ErrorTarget' = $_.Exception.TargetSite
        'CallStack' = (Get-PSCallStack)
    }
    try {
        $raPath = (Join-Path -Path $env:TEMP -ChildPath 'RedAlert.json')
        $redAlert | ConvertTo-Json -Depth 3 -EA Stop | 
            Set-Content -Path $raPath -Force -EA Stop
        Write-Warning ('Something unexpected has happened. Please help us make this tool better by providing the crash log which you find at {0}' -f $raPath)
    } catch {
        Write-Warning 'Something unexpected has happened and we couldn''t even save the crash log.'
    }
    <#
        IMPORTANT!
        Other cleanup and shutdown tasks
    #>
    $ErrorActionPreference = $prevEAP
    exit 1
}
#endregion
#region main script
$prevEAP = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

function Do-Stuff {
    Get-ChildItem f:\def
}
Do-Stuff

$ErrorActionPreference = $prevEAP
#endregion