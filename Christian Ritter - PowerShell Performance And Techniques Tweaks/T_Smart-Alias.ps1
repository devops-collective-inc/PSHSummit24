using namespace System.Management.Automation

return
#Smart-Alias

#Scenario: Multiple functions that act nearly identically, but have different names, and some different parameters.
function Get-ObjectTypeA {
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$Type,
        [Parameter(Mandatory)]
        [string]$Location
    )
    return [PSCustomObject]@{
        Name = $Name
        Type = $Type
        Location = $Location
    }
}
function Get-ObjectTypeB {
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$Type,
        [Parameter(Mandatory)]
        [string]$Color
    )
    return [PSCustomObject]@{
        Name = $Name
        Type = $Type
        Color = $Color
    }
}
function Get-ObjectTypeC {
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$Type,
        [Parameter(Mandatory)]
        [string]$Size
    )
    return [PSCustomObject]@{
        Name = $Name
        Type = $Type
        Size = $Size
    }
}

#Solution: Use a smart alias to create a single function that can be called with any of the names, and will automatically add the appropriate parameters.


#key benefit:
#1. The function can be called with any of the names, and will automatically add the appropriate parameters

function Get-ObjectType {
    [CmdletBinding()]
    [alias("Get-ObjectTypeLocation", "Get-ObjectTypeColor", "Get-ObjectTypeSize")]
    param(
        [Parameter(Mandatory,HelpMessage = "Parameter specifies Name")]
        
        $Name,
        $Type
    )
    dynamicparam{

        $CustomParameterNames = @("Location" ,"Size", "Color")
        $AllAttributes  = @{}
        foreach($CustomParameterName in $CustomParameterNames){  
            $AllAttributes[$CustomParameterName] = [ParameterAttribute]@{
                Mandatory = $true
                HelpMessage = "Parameter specifies $CustomParameterName"
            }
        }

        $SelectedCustomParameterName = $PSCmdlet.MyInvocation.InvocationName -Replace 'Get-ObjectType'

        $paramDictionary = [RuntimeDefinedParameterDictionary]::new()
        $attributes = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
        $attributes.Add($AllAttributes[$SelectedCustomParameterName])
        $paramDictionary.add($SelectedCustomParameterName, [RuntimeDefinedParameter]::new($SelectedCustomParameterName, [String], $attributes))
        

        # Return the collection of dynamic parameters
        $paramDictionary
    }
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        return [PSCustomObject]@{
            Name = $PSBoundParameters["Name"]
            Type = $PSBoundParameters["Type"]
            "$SelectedCustomParameterName" = $PSBoundParameters["$SelectedCustomParameterName"]
        }
    }
}