# how to concat strings in a fast way
# length: 9 characters, concating 10kb times

$RandomString = $((0..8).foreach({
    [char]$(Get-Random -Minimum 65 -Maximum 90)
}) -join "")

Measure-PSMDCommand -Iterations 1 -TestSet @{
    '+=' = {
        $Superlongstring = [string]::empty
        (0..10kb).foreach({
            $Superlongstring += $RandomString
        })
    }
    '-join' = {
        $Superlongstring = [string]::empty
        (0..10kb).foreach({
            $Superlongstring = -join($Superlongstring,$RandomString)
        })
    }
    'string-class' = {
        $Superlongstring = [string]::empty
        (0..10kb).foreach({
            $Superlongstring = [string]::Concat($Superlongstring,$RandomString)
        })
    }
    'String-Builder' = {
        $Superlongstring =  [System.Text.StringBuilder]::new()
        (0..10kb).foreach({
            $Superlongstring.append($RandomString) | Out-Null
        })
    }

}
<# Results
Name           Efficiency       Average
----           ----------       -------
String-Builder 1                00:00:00.5240336
+=             7.70020300225024 00:00:04.0351651
-join          14.9680835351016 00:00:07.8437787
string-class   29.5536851072145 00:00:15.4871240
#>

$RandomString = (0..10kb).ForEach({
    $((0..8).foreach({
        [char]$(Get-Random -Minimum 65 -Maximum 90)
    }) -join "")
})
Measure-PSMDCommand -Iterations 1 -TestSet @{
    '+=' = {
        $Superlongstring = [string]::empty
        $index = 0
        (0..10kb).foreach({
            $Superlongstring += $RandomString[$index]
            $index++
        })
    }
    '-join' = {
        $Superlongstring = [string]::empty
        $index = 0
        (0..10kb).foreach({
            $Superlongstring = -join($Superlongstring,$RandomString[$index])
            $index++
        })
    }
    'string-class' = {
        $Superlongstring = [string]::empty
        $index = 0
        (0..10kb).foreach({
            $Superlongstring = [string]::Concat($Superlongstring,$RandomString[$index])
            $index++
        })
    }
    'String-Builder' = {
        $Superlongstring =  [System.Text.StringBuilder]::new()
        $index = 0
        (0..10kb).foreach({
            $Superlongstring.append($RandomString[$index]) | Out-Null
            $index++
        })
    }

}
<# Results
Name           Efficiency       Average
----           ----------       -------
String-Builder 1                00:00:00.7265675
+=             5.02467589040247 00:00:03.6507662
-join          9.69863446961225 00:00:07.0467126
string-class   23.1861079665688 00:00:16.8462725
#>
