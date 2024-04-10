<#
    Function selection by using static parameter sets
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
function Explore-System {
    [CmdletBinding(DefaultParameterSetName='Default')]
    Param(
        [Parameter(Mandatory=$false, ParameterSetName='FileServer')]
        [switch]$FileServer,
        [Parameter(Mandatory=$false, ParameterSetName='FileServer')]
        [ValidateRange(1,10)]
        [int]$FolderDepth = 3,
        [Parameter(Mandatory=$false, ParameterSetName='AD')]
        [switch]$AD,
        [Parameter(Mandatory=$false, ParameterSetName='AD')]
        [string]$SearchBase,
        [Parameter(Mandatory=$false, ParameterSetName='AD')]
        [switch]$UseGC,
        [Parameter(Mandatory=$false, ParameterSetName='SQL')]
        [switch]$SQL,
        [Parameter(Mandatory=$false, ParameterSetName='SQL')]
        [string]$DatabaseName,
        [Parameter(Mandatory=$false, ParameterSetName='Linux')]
        [switch]$Linux,
        [Parameter(Mandatory=$false, ParameterSetName='Linux')]
        [switch]$TrustHostKey,
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    
    begin {
        Write-Host $PSCmdlet.ParameterSetName
    }
    process {
    
    }
    end {
        
    }
}