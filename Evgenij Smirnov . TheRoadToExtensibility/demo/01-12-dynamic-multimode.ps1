<#
    Function selection by using dynamic parameters
    To enable multiple selection, you have to drop
    Parameter Sets

    Dynamic Parameters do get created, but not fed back to Intellisense

#>
function Explore-System {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('FileServer','AD','SQL','Linux')]
        [string[]]$TargetSystem,
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    DynamicParam{
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        if ($TargetSystem -contains 'FileServer') {
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = 'Multimode'
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
        if ($TargetSystem -contains 'AD') {
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = "Multimode"
                Mandatory = $false
            }
            $attributeCollection.Add($parameterAttribute)
            $dynParam2 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                'SearchBase', [string], $attributeCollection
            )
            $paramDictionary.Add('SearchBase', $dynParam2)
            $dynParam3 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                'UseGC', [switch], $attributeCollection
            )
            $paramDictionary.Add('UseGC', $dynParam3)
        }
        if ($TargetSystem -contains 'SQL') {
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = 'Multimode'
                Mandatory = $false
            }        
            $attributeCollection.Add($parameterAttribute)
            $dynParam4 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                'DatabaseName', [string], $attributeCollection
            )
            $paramDictionary.Add('DatabaseName', $dynParam4)
            $validationAttribute = [System.Management.Automation.ValidateSetAttribute]::new(@('10','11','12','13'))
            $attributeCollection.Add($validationAttribute)
            $dynParam4a = [System.Management.Automation.RuntimeDefinedParameter]::new(
                'Version', [string], $attributeCollection
            )
            $paramDictionary.Add('Version', $dynParam4a)
        }
        if ($TargetSystem -contains 'Linux') {
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = 'Multimode'
                Mandatory = $false
            }        
            $attributeCollection.Add($parameterAttribute)
            $dynParam5 = [System.Management.Automation.RuntimeDefinedParameter]::new(
                'TrustHostKey', [switch], $attributeCollection
            )
            $paramDictionary.Add('TrustHostKey', $dynParam5)
        }
        return $paramDictionary
    }
    begin {
        Write-Host $TargetSystem
    }
    process {
    
    }
    end {
        
    }
}