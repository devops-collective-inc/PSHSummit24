#Region Data preperation
$NumbersExtraLarge  = get-random -min 0 -max 1gb -count 40mb
$NumbersLarge       = get-random -min 0 -max 1gb -count 20mb
$NumbersMedium      = get-random -min 0 -max 1gb -count 1mb
$NumbersSmall       = get-random -min 0 -max 1gb -count 100kb
$Numberstiny        = get-random -min 0 -max 1gb -count 100
#EndRegion


#Region Methods analyzing

# Goal: Get the maximum value from a lot of data
$SampleNumbers = 1,3,6,14,32,19

# Method: Measure-Object

$SampleNumbers | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

# Method: Sort-Object Descending -> Select first

$SampleNumbers | Sort-Object -Descending | Select-Object -First 1

# Method: Looping or Math class approach

# lets assume the first number is the largest number in our array
$LargestNumber = $SampleNumbers[0] 

foreach($Number in $SampleNumbers){
    # The Max method will return the largest number between to numbers
    # So $LargestNumber will contain after looping once all $SampleNumbers, the maximum number
    $LargestNumber = [System.Math]::Max($Number,$LargestNumber) 
}

$LargestNumber

#EndRegion

#Region Tests:
import-module Benchpress




bench -Technique @{
    "Math" = {
        $MaxValue = $NumbersMedium[0]
        foreach($num in $NumbersMedium){
            $MaxValue = [System.Math]::Max($MaxValue,$num)
        }
    }
    "Sort" = {
        $MaxValue = ($NumbersMedium|Sort-Object)[-1]
    }
    "Measure" = {
        $MaxValue = ($NumbersMedium|Measure-Object -Maximum).Maximum
    }
} -RepeatCount 5 -GroupName "Medium Size"
<#
    Technique Time            RelativeSpeed Throughput
    --------- ----            ------------- ----------
    Math      00:00:03.122723 1x            1.6/s
    Measure   00:00:10.519185 3.37x         0.48/s
    Sort      00:01:09.471032 22.25x        0.07/s
#>

bench -Technique @{
    "Math" = {
        $MaxValue = $NumbersSmall[0]
        foreach($num in $NumbersSmall){
            $MaxValue = [System.Math]::Max($MaxValue,$num)
        }
    }
    "Sort" = {
        $MaxValue = ($NumbersSmall|Sort-Object)[-1]
    }
    "Measure" = {
        $MaxValue = ($NumbersSmall|Measure-Object -Maximum).Maximum
    }
} -RepeatCount 5 -GroupName "Small Size"

<#
    Technique Time            RelativeSpeed Throughput
    --------- ----            ------------- ----------
    Math      00:00:00.266263 1x            18.78/s
    Measure   00:00:00.916442 3.44x         5.46/s
    Sort      00:00:03.602889 13.53x        1.39/s
#>

bench -Technique @{
    "Math" = {
        $MaxValue = $NumbersLarge[0]
        foreach($num in $NumbersLarge){
            $MaxValue = [System.Math]::Max($MaxValue,$num)
        }
    }
    "Sort" = {
        $MaxValue = ($NumbersLarge|Sort-Object)[-1]
    }
    "Measure" = {
        $MaxValue = ($NumbersLarge|Measure-Object -Maximum).Maximum
    }
} -RepeatCount 5 -GroupName "Large Size"

<#
    Technique Time            RelativeSpeed Throughput
    --------- ----            ------------- ----------
    Math      00:01:18.456049 1x            0.06/s
    Measure   00:03:53.469569 2.98x         0.02/s
    Sort      00:32:18.084025 24.7x         0/s
#>

bench -Technique @{
    "Math" = {
        $MaxValue = $Numberstiny[0]
        foreach($num in $Numberstiny){
            $MaxValue = [System.Math]::Max($MaxValue,$num)
        }
    }
    "Sort" = {
        $MaxValue = ($Numberstiny|Sort-Object)[-1]
    }
    "Measure" = {
        $MaxValue = ($Numberstiny|Measure-Object -Maximum).Maximum
    }
} -RepeatCount 5 -GroupName "tiny Size"

<#
    Technique Time            RelativeSpeed Throughput
    --------- ----            ------------- ----------
    Measure   00:00:00.002011 1x            2485.58/s
    Sort      00:00:00.004779 2.38x         1046.09/s
    Math      00:00:00.009867 4.91x         506.73/s
#>

bench -Technique @{
    "Math" = {
        $MaxValue = $NumbersExtraLarge[0]
        foreach($num in $NumbersExtraLarge){
            $MaxValue = [System.Math]::Max($MaxValue,$num)
        }
    }
    "Measure" = {
        $MaxValue = ($NumbersExtraLarge|Measure-Object -Maximum).Maximum
    }
} -RepeatCount 1 -GroupName "Extra Large Size"

<#
    Technique Time            RelativeSpeed Throughput
    --------- ----            ------------- ----------
    Math      00:00:47.465997 1x            0.02/s
    Measure   00:02:23.214019 3.02x         0.01/s
#>

#EndRegion


