<#
    PowerBall Ticket Validation
    - ValidateSet
    - JSON Schema Validation
    - Performance Test

    Conditions:
    - Name is a string
    - Age is an integer between 18 and [int]::MaxValue
    - Numbers is an array of 6 integers between 1 and 69
#>

#Region Functions
function New-PowerBallTicketValidateSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateRange(18, [int]::MaxValue)]
        [int]$Age,

        [Parameter(Mandatory = $true)]
        [ValidateCount(6, 6)]
        [ValidateRange(1, 69)]
        [int[]]$Numbers
    )
    return $PSBoundParameters

}
# may be show the creation process via AI and show Schema def.
function New-PowerBallTicketJsonSchemaValadation {
    [CmdletBinding()]
    param (
        $Name,
        $Age,
        $Numbers
    )
    
    $jsonSchemaHashtable = @{
        '$schema'    = 'http://json-schema.org/draft-07/schema#'
        'type'       = 'object'
        'properties' = @{
            'Name'    = @{
                'type' = 'string'
            }
            'Age'     = @{
                'type'    = 'integer'
                'minimum' = 18
            }
            'Numbers' = @{
                'type'     = 'array'
                'items'    = @{
                    'type'    = 'integer'
                    'minimum' = 1
                    'maximum' = 69
                }
                'minItems' = 6
                'maxItems' = 6
            }
        }
        'required'   = @('Name', 'Age', 'Numbers')
    }
    if (-not($PSBoundParameters | ConvertTo-Json -Depth 6 | Test-Json -Schema $($jsonSchemaHashtable | Convertto-Json -Depth 6))) {
        return
    }

    return $PSBoundParameters

}
#endregion

#Region Usage
$newPowerBallTicketSplatWorking = @{
    Name    = 'John Doe'
    Age     = 18
    Numbers = 1, 2, 3, 4, 5, 6
}
$newPowerBallTicketSplatFailing = @{
    Name    = 'John Doe'
    Age     = 18
    Numbers = 1, 2, 3, 4, 5, 677
}

# ValidateSet
New-PowerBallTicketValidateSet @newPowerBallTicketSplatWorking
New-PowerBallTicketValidateSet @newPowerBallTicketSplatFailing

# JSON Schema Validation
New-PowerBallTicketJsonSchemaValadation @newPowerBallTicketSplatWorking
New-PowerBallTicketJsonSchemaValadation @newPowerBallTicketSplatFailing
#endregion

#Region Performance Test

$TestJSON = Measure-Command {
    0..10kb | ForEach-Object {
        New-PowerBallTicketJsonSchemaValadation @newPowerBallTicketSplatWorking
    }
}

$TestValidateSet = Measure-Command {
    0..10kb | ForEach-Object {
        New-PowerBallTicketValidateSet @newPowerBallTicketSplatWorking 
    }
}

# Results
[PSCustomObject]@{
    TestJSON        = $TestJSON
    TestValidateSet = $TestValidateSet
} | Format-List
#endregion
return

#Region real world example
# Define a PowerShell class named JSONTransform that inherits from System.Management.Automation.ArgumentTransformationAttribute
class JSONTransform : System.Management.Automation.ArgumentTransformationAttribute{
    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics,[object]$InputData){
        # Define a JSON schema for the batch graph request
        $batchGraphRequestSchema = @{
            '$schema' = 'http://json-schema.org/draft-07/schema#'
            'type' = 'object'
            'properties' = @{
                'requests' = @{
                    'type' = 'array'
                    'items' = @{
                        'type' = 'object'
                        'properties' = @{
                            'id' = @{
                                'type' = 'string'
                            }
                            'method' = @{
                                'type' = 'string'
                                'enum' = @('GET', 'PUT', 'PATCH', 'POST', 'DELETE')
                            }
                            'url' = @{
                                'type' = 'string'
                                'pattern' = '^\/[a-zA-Z0-9\/$&=?,]+$'
                            }
                            'headers' = @{
                                'type' = 'object'
                                # Additional properties for headers schema if needed
                            }
                            'body' = @{
                                'type' = 'object'
                                # Additional properties for body schema if needed
                            }
                        }
                        'required' = @('id', 'method', 'url')
                        'propertyNames' = @{
                            'enum' = @('id', 'method', 'url', 'headers', 'body')
                        }
                    }
                }
            }
            'required' = @('requests')
        }

        # Initialize a counter object to keep track of the number of items processed
        $counter = [pscustomobject] @{ Value = 0 }

        # Set the batch size to 20
        $BatchSize = 20

        # Group the input data into batches based on the batch size
        $Batches = $InputData | Group-Object -Property { [math]::Floor($counter.Value++ / $BatchSize) }

        # Process each batch and convert it to JSON
        $ReturnBatches = foreach($Batch in $Batches){
            $ReturnObject = @{
                requests = $Batch.Group
            } | ConvertTo-Json -Depth 6
    
            try {
                # Validate the JSON object against the batch graph request schema
                $Null = $ReturnObject | Test-Json -Schema $($batchGraphRequestSchema | Convertto-Json -Depth 6) -ErrorAction Stop
            }
            catch {
                # If the validation fails, write the invalid JSON object and throw an exception
                write-host $ReturnObject
                Throw "$($_.Exception.Message). JSON Schema did not match"
            }
            $ReturnObject
        }

        # Return the processed batches
        return $ReturnBatches
    }
}

function ConvertTo-MSGraphBatchRequest {
    [CmdletBinding()]
    param (
        [jsontransform()]$Requests
    )
    
    begin {

    }
    
    process {
        
    }
    
    end {
        return $Requests
    }
}
#endregion