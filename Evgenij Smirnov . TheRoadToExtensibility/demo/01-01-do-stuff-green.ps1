<#
    This script has a default Parameter Set that
    catches the parameter-less invocation
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region head
[CmdletBinding(DefaultParameterSetName='Welcome')]
Param(
    [Parameter(Mandatory=$true,ParameterSetName='ComputerName')]
    [string]$ComputerName,
    [Parameter(Mandatory=$true,ParameterSetName='IPAddress')]
    [string]$IPAddress
)
#endregion
#region body
switch ($PSCmdlet.ParameterSetName) {
    'Welcome' {
        Write-Host 'Let''s do great things! For that, you have to specify a target - either by its computer name (-ComputerName parameter) or by its IP address (-IPAddress parameter).' -ForegroundColor Green
    }
    'ComputerName' { 
            Write-Host ('The little machine named {0}' -f $ComputerName)
        }
    'IPAddress' { 
            Write-Host ('Saving cycles on name resolution {0}' -f $IPAddress)
        }
}
start $PSScriptRoot
#endregion