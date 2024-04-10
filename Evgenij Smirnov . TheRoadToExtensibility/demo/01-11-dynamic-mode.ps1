<#
    Function selection by using dynamic parameters
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
function Explore-System {
    [CmdletBinding(DefaultParameterSetName='Default')]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('FileServer','AD','SQL','Linux')]
        [string]$TargetSystem,
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    DynamicParam{
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        switch ($TargetSystem) {
            'FileServer' {
                $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
                $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                    ParameterSetName = 'FileServer'
                    Mandatory = $false
                }        
                $attributeCollection.Add($parameterAttribute)
                $validationAttribute = [System.Management.Automation.ValidateRangeAttribute]::new(1,10)
                $attributeCollection.Add($validationAttribute)
                $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    'FolderDepth', [Int32], $attributeCollection
                )
                $dynParam1.Value = 3
                $paramDictionary.Add('FolderDepth', $dynParam1)
            }
            'AD' {
                $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
                $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                    ParameterSetName = "AD"
                    Mandatory = $false
                }
                $attributeCollection.Add($parameterAttribute)
                $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    'SearchBase', [string], $attributeCollection
                )
                $paramDictionary.Add('SearchBase', $dynParam1)
                $dynParam2 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    'UseGC', [switch], $attributeCollection
                )
                $paramDictionary.Add('UseGC', $dynParam2)
            }
            'SQL' {
                $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
                $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                    ParameterSetName = 'SQL'
                    Mandatory = $false
                }        
                $attributeCollection.Add($parameterAttribute)
                $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    'DatabaseName', [string], $attributeCollection
                )
                $paramDictionary.Add('DatabaseName', $dynParam1)
            }
            'Linux' {
                $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
                $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                    ParameterSetName = 'Linux'
                    Mandatory = $false
                }        
                $attributeCollection.Add($parameterAttribute)
                $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                    'TrustHostKey', [switch], $attributeCollection
                )
                $paramDictionary.Add('TrustHostKey', $dynParam1)
            }
        }
        return $paramDictionary
    }
    begin {
        Write-Host $PSCmdlet.ParameterSetName
    }
    process {
    
    }
    end {
        
    }
}