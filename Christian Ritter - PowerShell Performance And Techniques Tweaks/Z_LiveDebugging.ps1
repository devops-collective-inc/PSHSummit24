$blah -eq $nul

function Get-Weather {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$City
    )

    # Check if the city is known
    if ($City -eq "Seattle") {
        # Add a dynamic parameter for temperature unit
        DynamicParam {
            $attribute = New-Object System.Management.Automation.ParameterAttribute
            $attribute.Mandatory = $true

            $validateSet = New-Object System.Management.Automation.ValidateSetAttribute("Celsius", "Fahrenheit")
            $attribute.Attributes.Add($validateSet)

            $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter("Unit", [string], $attribute)
            $parameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $parameterDictionary.Add("Unit", $parameter)

            return $parameterDictionary
        }
    }

    # Get the weather information
    # ...

    # Display the weather information
    # ...
}
$Routes = "User","Device"

function Get-EndpointInfo {
    [CmdletBinding()]
    param (
        $ID
    )
    dynamicparam{
        $ParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $Routes.ForEach({
            $ParameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                Mandatory = $true
                ParameterSetName = "/$_/ID/Info"
            }
            $AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $AttributeCollection.Add($ParameterAttribute)

            $DynamicParameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                $_,[switch],$AttributeCollection
            )
            $ParameterDictionary.Add($_,$DynamicParameter)

        })
        return $ParameterDictionary
    }
    process{
        $PSBoundParameters.GetEnumerator().Where({$_.Value -eq $true}).ForEach({
            Write-Host "Call Endpoint: /$($_.Key)/$ID/Info"
        })
    }
}

filter Test{
    Write-Host $_
}

$Routes | Test