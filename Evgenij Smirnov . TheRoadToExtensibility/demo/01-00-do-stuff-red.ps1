<#
    This script cannot be invoked without parameters
    because the ParameterSetName cannot be resolved

    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region head
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,ParameterSetName='ComputerName')]
    [string]$ComputerName,
    [Parameter(Mandatory=$true,ParameterSetName='IPAddress')]
    [string]$IPAddress
)
#endregion
#region body
switch ($PSCmdlet.ParameterSetName) {
    'ComputerName' { 
            Write-Host ('The little machine named {0}' -f $ComputerName)
        }
    'IPAddress' { 
            Write-Host ('Saving cycles on name resolution {0}' -f $IPAddress)
        }
}
#endregion