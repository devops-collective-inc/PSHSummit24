# How to check if something is null
# If its null return Assignment else return Value

#region Methods

$Assignment = $null # Test with null and "is assigned"

# Method: -eq $null
$Assignment = if($null -eq $Assignment){"Assignment"}else{$Assignment}
$Assignment

# Method: -eq $null, Ternary
$Assignment = ($null -eq $Assignment)?"Assignment":$Assignment
$Assignment

# Method: String Class, If
$Assignment = if([string]::IsNullOrEmpty($Assignment)){"Assignment"}else{$Assignment}
$Assignment

# Method: Null conditional assignment operator
$Assignment = [string]::IsNullOrEmpty($Assignment)?"Assignment":$Assignment
$Assignment

# Method: Null conditional assignment operator
$Assignment = $Assignment ??= "Assignment"
$Assignment

#endregion

#region Tests
$Script:MyStack = New-Object System.Collections.Stack  

1..256 | ForEach-Object {$script:MyStack.Push($($null, 'Assignment' | get-random))}
$Tests = 1..50 | ForEach-Object {
    $Script:InputX = $script:MyStack.pop()
    Measure-PSMDCommand -Iterations 1 -TestSet @{
        "Null conditional assignment operator"  = {
            0..10000|foreach-object{
                $X = $Script:InputX ??= "Assignment"
            }
        }
        "String Class, If"                      = {
            0..10000|foreach-object{
                $X = if([string]::IsNullOrEmpty($Script:InputX)){"Assignment"}else{$Script:InputX}
            }
        }
        "String Class, ternary"                 = {
            0..10000|foreach-object{
                $X = [string]::IsNullOrEmpty($Script:InputX)?"Assignment":$InputX
            }
        }
        '-eq $null, if'                         = {
            0..10000|foreach-object{
                $X = if($null -eq $script:Inputx){"Assignment"}else{$Script:InputX} 
            }
        }
        '-eq $null, Ternary'                    = {
            0..10000|foreach-object{
                $X = ($null -eq $script:InputX)?"Assignment":$Script:InputX 
            }
        }
        
    } 
}
$Tests | group-object -Property Name | Select-Object Name, @{Name="AVG";Expression={($_.Group.Average.Ticks | measure-object -Average | Select-Object -ExpandProperty Average) / 1000}} | Sort-Object -Property AVG
<#
Name                                     AVG
----                                     ---
Null conditional assignment operator 4441.98
-eq $null, if                        4730.95
String Class, ternary                5313.93
String Class, If                     5872.37
-eq $null, Ternary                   7355.86
#>

#endregion