#Region Regular ValidateSet
function Test-ValidateSet {
    [CmdletBinding()]
    param (
        [ValidateSet('A','B','C')]
        [string]$Test
    )
    $Test
}
Test-ValidateSet -Test 'D'
#Endregion

#Region ValidateSet with default value
function Test-ValidateSetWithDefault {
    [CmdletBinding()]
    param (
        [ValidateSet('A','B','C')]
        [string]$Test = 'D'
    )
    $Test
}
Test-ValidateSetWithDefault 
Test-ValidateSetWithDefault -Test A
Test-ValidateSetWithDefault -Test D 

#EndRegion

#Region ValidateSet with Enum

# Listing an Enum
[Enum]::GetNames( [System.DayOfWeek] )

function Test-ValidateSetWithEnum {
    [CmdletBinding()]
    param (
        [System.DayOfWeek]$Test
    )
    $Test
}
Test-ValidateSetWithEnum -Test "Wednesday"
Test-ValidateSetWithEnum -Test "WaistcoatWednesday"
#EndRegion

#Region ValidateSet with custom Enum
enum acceptedInput {
    A
    B
    C
}
function Test-ValidateSetWithCustomEnum {
    [CmdletBinding()]
    param (
        [acceptedInput]$Test ="D"
    )
    $Test
}
Test-ValidateSetWithCustomEnum #Default Value
Test-ValidateSetWithCustomEnum -Test A
#EndRegion

#Region ValidateSet with Class

#Region Simple Class and function
class RegexExpression : System.Management.Automation.IValidateSetValuesGenerator {
    static [Hashtable] $Patterns = @{ 
        'Email'     = '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$'
        'Phone'     = '^\d{3}-\d{3}-\d{4}$'
        'Url'       = '^(https?|ftp)://[^\s/$.?#].[^\s]*$'
        'IP'        = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' 
    }

    [String[]] GetValidValues() {
        return [RegexExpression]::Patterns.Keys
    }
}

function Test-ValidateSetWithClass {
    [CmdletBinding()]
    param (
        [ValidateSet([RegexExpression],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        $Test
    )
    [RegexExpression]::Patterns[$Test]
}

Test-ValidateSetWithClass -Test "URL"
Test-ValidateSetWithClass -Test "URi"
#EndRegion

#If we have spare time theyre is even more

#Region Simple class and multiple reliable Parameter
# Warning: This is no good practice, its just for demonstrating a thing and pushing boundaries :)
# lets put some 'cherrys' on top and rely on the input of one paramter for another
function Test-ValidateSetWithClassAdvanced {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet([RegexExpression],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        $Type,
        [Parameter(Position = 1)]
        [ValidateScript({ $_ -match [RegexExpression]::Patterns[$Type] }, ErrorMessage = 'InputType does not match input')]
        $TestString
    )
    Write-Host $TestString
}

#Works
Test-ValidateSetWithClassAdvanced -Type IP -TestString "111.33.22.44"  

#Dont Work
Test-ValidateSetWithClassAdvanced  -TestString "111.33.22.44" -Type IP  

#Works sometimes
$testValidateSetWithClassAdvancedSplat = @{
    Type = 'IP'
    TestString = "111.33.22.44"
}
Test-ValidateSetWithClassAdvanced @testValidateSetWithClassAdvancedSplat




# Lets investigate why it only sometimes works

$TestScript = {
    class RegexExpression : System.Management.Automation.IValidateSetValuesGenerator {
        static [Hashtable] $Patterns = @{ 
            'Email'     = '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$'
            'Phone'     = '^\d{3}-\d{3}-\d{4}$'
            'Url'       = '^(https?|ftp)://[^\s/$.?#].[^\s]*$'
            'IP'        = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' 
        }
    
        [String[]] GetValidValues() {
            return [RegexExpression]::Patterns.Keys
        }
    }

    function Test-ValidateSetWithClassAdvanced {
        [CmdletBinding()]
        param (
            [Parameter(Position = 0)]
            [ValidateSet([RegexExpression],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
            $Type,
            [Parameter(Position = 1)]
            [ValidateScript({ $_ -match [RegexExpression]::Patterns[$Type] }, ErrorMessage = 'InputType does not match input')]
            $TestString
        )
        #Write-Host $TestString
    }

    $testValidateSetWithClassAdvancedSplat = @{
        Type = 'IP'
        TestString = "111.33.22.44"
    }
    
    
    try {
        Test-ValidateSetWithClassAdvanced @testValidateSetWithClassAdvancedSplat  
        "Good"
    }
    catch {
        "Bad"
    }
}
$Feedback = 1..10 | ForEach-Object  {
    [PSCustomObject]@{
        ID = $_
        Result = start-job -ScriptBlock $TestScript | Wait-Job | Receive-Job
    }
    
}
"worked: $(($Feedback | Where-Object Result -eq 'Good').count) | $($Feedback.Count)"


# Lets fix this 
$TestScriptOrdered = {
    class RegexExpression : System.Management.Automation.IValidateSetValuesGenerator {
        static [Hashtable] $Patterns = @{ 
            'Email'     = '^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$'
            'Phone'     = '^\d{3}-\d{3}-\d{4}$'
            'Url'       = '^(https?|ftp)://[^\s/$.?#].[^\s]*$'
            'IP'        = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' 
        }
    
        [String[]] GetValidValues() {
            return [RegexExpression]::Patterns.Keys
        }
    }

    function Test-ValidateSetWithClassAdvanced {
        [CmdletBinding()]
        param (
            [Parameter(Position = 0)]
            [ValidateSet([RegexExpression],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
            $Type,
            [Parameter(Position = 1)]
            [ValidateScript({ $_ -match [RegexExpression]::Patterns[$Type] }, ErrorMessage = 'InputType does not match input')]
            $TestString
        )
        #Write-Host $TestString
    }

    $testValidateSetWithClassAdvancedSplat = [ordered]@{
        Type = 'IP'
        TestString = "111.33.22.44"
    }
    
    try {
        Test-ValidateSetWithClassAdvanced @testValidateSetWithClassAdvancedSplat  
        "Good"
    }
    catch {
        "Bad"
    }
}

$FeedbackOrdered = 1..10 | ForEach-Object  {
    [PSCustomObject]@{
        ID = $_
        Result = start-job -ScriptBlock $TestScriptOrdered | Wait-Job | Receive-Job
    }
    
}

"worked ordered: $(($FeedbackOrdered | Where-Object Result -eq 'Good').count) | $($FeedbackOrdered.Count)"


# Prove that Hashtables dont care about the order

$HashtableTestScript = {
    @{
        Type = 'A'
        TestString = 'Hello'
    }
}

$FeedbackHashtable = 1..10 | ForEach-Object  {
    [PSCustomObject]@{
        Result = $Result = start-job -ScriptBlock $HashtableTestScript | Wait-Job | Receive-Job
        FirstEntry = $Result.GetEnumerator().Name[0]
    }
    
}
"Hashtable 'Type' first entry: $(($FeedbackHashtable | Where-Object FirstEntry -eq 'Type').count) | $($FeedbackHashtable.Count)"
#EndRegion

#EndRegion