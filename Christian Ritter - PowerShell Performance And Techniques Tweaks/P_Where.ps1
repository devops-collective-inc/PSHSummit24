$HugeListOfRandomObjects = (Get-Random -Count 1Mb -Minimum 1 -Maximum 9Mb).ForEach({
    [PSCustomObject]@{
        Name = [System.Guid]::NewGuid().ToString()
        Number = $_
    }
})
$HugeListOfRandomObjects = Import-Csv -Delimiter ";" -Path .\HugeFileList.txt -Encoding UTF8
$HugeListOfRandomObjects | Export-CSV -Path "$pwd\HugeFileList.txt" -Delimiter ';' -Encoding utf8 -NoTypeInformation

Measure-PSMDCommand -Iterations 5 -TestSet @{
    "Where-Object"      = {$HugeListOfRandomObjects[0..200kb] | Where-Object Number -gt 7000}
    "Where-Object{}"    = {$HugeListOfRandomObjects[0..200kb] | Where-Object {$_.Number -gt 7000}}
    ".Where()"          = {$HugeListOfRandomObjects[0..200kb].Where({$_.Number -gt 7000})}
    "Foreach-Object"    = {$HugeListOfRandomObjects[0..200kb] | Foreach-Object {if ($_.Number -gt 7000) {$_}}}
    ".Foreach()"        = {$HugeListOfRandomObjects[0..200kb].ForEach({$_.Number -gt 7000})}
}
<#
    Results:
        Name           Efficiency       Average
        ----           ----------       -------
        .Where()       1                00:00:00.6875811
        .Foreach()     1.71346056487009 00:00:01.1781431
        Foreach-Object 1.89995681963917 00:00:01.3063744
        Where-Object   2.89168506813233 00:00:01.9882680
        Where-Object{} 3.41437482792939 00:00:02.3476596
#>
Measure-PSMDCommand -Iterations 5 -TestSet @{
    "Like" = {$HugeListOfRandomObjects[0..100kb].where({$_.Name -like "cbb45906-1255-44f4*"})}
    "Regex" = {$HugeListOfRandomObjects[0..100kb].where({$_.Name -match "cbb45906-1255-44f4*"})}
    "Eq-substring" = {$HugeListOfRandomObjects[0..100kb].where({$_.Name.substring(0,9) -eq "cbb45906-"})}
    "Eq" = {$HugeListOfRandomObjects[0..100kb].where({ "$($_.Name[0..8] -join '')" -eq "cbb45906-"})}
}
<# 
    Results:
        Name         Efficiency       Average
        ----         ----------       -------
        Like         1                00:00:00.3296555
        Regex        1.1895624371503  00:00:00.3921458
        Eq-substring 1.25775453465815 00:00:00.4146257
        Eq           4.25348613931817 00:00:01.4021851

#>

Measure-PSMDCommand -Iterations 5 -Testset @{
    "Like - Wildcard" = {$HugeListOfRandomObjects[0..400kb].where({$_.Name -like "*cbb45906-1255-44f4-b762-1877554e2496*"})}
    "Like" = {$HugeListOfRandomObjects[0..400kb].where({$_.Name -like "cbb45906-1255-44f4-b762-1877554e2496"})}
    "Eq" = {$HugeListOfRandomObjects[0..400kb].where({$_.Name -eq "cbb45906-1255-44f4-b762-1877554e2496"})}
}
<#
    Results:
        Name            Efficiency       Average
        ----            ----------       -------
        Eq              1                00:00:01.2938326
        Like            1.03666525329475 00:00:01.3412713
        Like - Wildcard 1.51199196866735 00:00:01.9562645
#>