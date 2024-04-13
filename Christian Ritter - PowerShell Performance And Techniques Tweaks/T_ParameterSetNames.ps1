# Even more Dynamic functions and ValidateSet thingies or how to smuggle data with ParameterSetNames

<#task: 
    Write a function that calls different endpoints like Device or User Route
    e.g /Device/<ID>/Info based on parameter input...
#>

#region Simple solution, not much flexible
function Get-EndpointInfo {
    Param(
        [ValidateSet("Device","User")]
        $Type,
        $ID
    )
    Write-Host "Call Endpoint: /$Type/$ID/Info"
}

#endregion

#region also a simple solution, but users of the function dont have to type or complete the endpoint
function Get-EndpointInfo {
    Param(
        $ID,
        [Parameter(ParameterSetName = "User")]
        [switch] $User,
        [Parameter(ParameterSetName = "Device")]
        [switch] $Device
        )
        
        Write-Host "Call Endpoint: /$($PSCmdlet.ParameterSetName)/$ID/Info"
}
#endregion
<# 
    less text in process block, 
    if the routes may be not like the user e.g.:
        /User/alluser/<ID>/Info
        /Device/<Location>/<ID>/Info
        ...
    Bonus, no switching there   
#>
function Get-EndpointInfo {
    param (
        $ID,
        [Parameter(ParameterSetName='/User/{0}/Info')]
        [switch]$User,
        [Parameter(ParameterSetName='/Device/{0}/Info')]
        [switch]$Device
    )
    Write-Host "Call Endpoint: $($PSCmdlet.ParameterSetName -f $ID)"
}

<#
    Solution with dynamic parameters, unhandy for a few routes, may come in handy for a ton of routes :)
#>
$Routes = @{
    User = "/User/{0}/Info"
    Device = "/Device/{0}/Info"
}
function Get-EndpointInfo {
    [CmdletBinding()]
    param (
        $ID
    )
    dynamicparam{
        $ParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $Routes.GetEnumerator().Name.ForEach({
            $ParameterAttribute = [System.Management.Automation.ParameterAttribute]@{
                ParameterSetName = $Routes["$_"]
                Mandatory = $true
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
        Write-Host "Call Endpoint: $($PSCmdlet.ParameterSetName -f $ID)"
    }
}