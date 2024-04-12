$HugeFilePath = "$pwd\HugeFileList.txt"

Measure-PSMDCommand -Iterations 1 -Testset @{
    "Get-Content" = {
        $HugeListOfRandomObjectsImport = Get-Content -Path $HugeFilePath
    }
    "Switch" = {
        $HugeListOfRandomObjectsImport = Switch -file ($HugeFilePath){
            Default {$_}
        }
    }
    "File-Class" = {
        $HugeListOfRandomObjectsImport = [System.IO.File]::ReadAllLines($HugeFilePath)
    }
    "StreamReader" = {
        $HugeListOfRandomObjectsImport = New-Object System.IO.StreamReader -ArgumentList $HugeFilePath
        $HugeListOfRandomObjectsImport = while($line = $HugeListOfRandomObjectsImport.ReadLine()){
            $line
        }
    }
}
<#
    Results:
        Name         Efficiency       Average
        ----         ----------       -------
        File-Class   1                00:00:00.8373940
        Switch       1.77258590340986 00:00:01.4843528
        StreamReader 3.72453635922875 00:00:03.1189044
        Get-Content  20.7072062852134 00:00:17.3400903
#>


Measure-PSMDCommand -Iterations 15 -Testset @{
    "Switch" = {
        $HugeListOfRandomObjectsImport = Switch -file ($HugeFilePath){
            Default {$_}
        }
    }
    "File-Class" = {
        $HugeListOfRandomObjectsImport = [System.IO.File]::ReadAllLines($HugeFilePath)
    }
}

<#
    Results:
        Name       Efficiency       Average
        ----       ----------       -------
        File-Class 1                00:00:00.3965270
        Switch     1.88052465531981 00:00:00.7456788
#>

1..5 | ForEach-Object{ 
    Start-Job -ScriptBlock{
        $HugeFilePath = "$using:pwd\HugeFileList.txt"
        $HugeListOfRandomObjectsImport = [System.IO.File]::ReadAllLines($HugeFilePath)
        $RandomLine = ($HugeListOfRandomObjectsImport[(Get-Random -minimum 100000 -maximum 1048579)] -split " ")[0]
        Measure-PSMDCommand -iterations 1 -TestSet @{
            "Switch - Default" = {
                $Search = Switch -file ($HugeFilePath){
                    Default {
                        if($_ -like "*$RandomLine*"){
                            $_
                            break
                        }
                    }
                }
            }
            "Switch - Case" = {
                $Search = Switch -file ($HugeFilePath){
                    {$_ -like "*$RandomLine*"} {
                        $_
                        break
                    }
                }
            }
            "StreamReader - Default" = {
                $HugeListOfRandomObjectsImport = New-Object System.IO.StreamReader -ArgumentList $HugeFilePath
                $Search = while($line = $HugeListOfRandomObjectsImport.ReadLine()){
                    if($line -like "*$RandomLine*"){
                        $line
                        break
                    }
                }
                $HugeListOfRandomObjectsImport.close()
            }
        }

    } | wait-job | receive-job
} | group-object -Property Name | Select-Object Name, @{
    Name="AVG"
    Expression={($_.Group.Average.Ticks | measure-object -Average | Select-Object -ExpandProperty Average) }} | 
    Sort-Object -Property AVG

<#
    Results:
        Name                           AVG
        ----                           ---
        Switch - Default       19131599.80
        StreamReader - Default 28891805.60
        Switch - Case          40893441.60
#>