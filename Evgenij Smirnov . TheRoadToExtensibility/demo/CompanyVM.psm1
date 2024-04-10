<#
    Inventory.TheWorld

    2024 Evgenij Smirnov
#>
function Get-CompanyVM {
    [CmdletBinding()]
    Param()
    Write-Host $ErrorActionPreference -ForegroundColor Cyan
}

function Restart-CompanyVM {
    [CmdletBinding()]
    Param()
    trap { Invoke-RedAlert }
    Get-ChildItem f:\def
}
$script:Version = '0.2.9'
#region red alert
function Invoke-RedAlert {
    Write-Host 'Red Alert' -ForegroundColor Red
    $redAlert = [PSCustomObject]@{
        'ErrorMessage' = $_.Exception.Message
        'ErrorSource' = $_.Exception.Source
        'StackTrace' =  $_.Exception.StackTrace 
        'ErrorTarget' = $_.Exception.TargetSite
        'CallStack' = (Get-PSCallStack) | Select-Object -Skip 1
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
    exit 1
}
#endregion
$ErrorActionPreference = 'Stop'
Export-ModuleMember -Function @('Get-CompanyVM','Restart-CompanyVM')
