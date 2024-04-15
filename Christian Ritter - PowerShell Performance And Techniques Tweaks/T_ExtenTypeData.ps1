# Task: Check if Files are older than X Days

Get-ChildItem -Path C:\Temp\ -File | Where-Object{
    $_.LastWriteTime -lt ((Get-Date).AddDays(-5))
}

#example of extending FilInfo object with a new method 'OlderThan' x days
$ExtendMethodOlderThan = {
    Param(
        [int]$Days
    )
    $Now = Get-Date
    $OlderThan = $Now.AddDays(-$Days)
    return ($this.LastWriteTime -lt $OlderThan) ? $true : $false
}
$etd = @{
    TypeName = 'System.IO.FileInfo'
    MemberType = 'ScriptMethod'
    MemberName = 'OlderThan'
    Value = $ExtendMethodOlderThan
}
Update-TypeData @etd


Get-Childitem -Path C:\Temp -File | get-member | Where-Object Name -eq Basename | Select-Object -ExpandProperty Definition

#usage:
$File = Get-Childitem -Path 'C:\temp\' -File
$File.OlderThan(50)

$File | Where-Object {$_.OlderThan(50)}
#conclusion: this method approach is only useful for more or less interactive use

#example of extending FilInfo object with a new property 'OlderThan' x days (X needs to be defined first)

$ExtendPropertyOlderThan = {
    $Days = 5
    $Now = Get-Date
    $OlderThan = $Now.AddDays(-$Days)
    return ($this.LastWriteTime -lt $OlderThan) ? $true : $false
}
$etd = @{
    TypeName = 'System.IO.FileInfo'
    MemberType = 'ScriptProperty'
    MemberName = 'OlderThan5'
    Value = $ExtendPropertyOlderThan
}
Update-TypeData @etd

#usage: 
$File = Get-Childitem -Path 'C:\temp\' -File
$File | Where-Object OlderThan5


#example of implementing a method to get a default value from a hashtable
#Scenario: You need to translate numbers to language settings, 
#   e.g. 1 to German, 2 to French and so on, if a number does not match, 
#   then we want to return a default value, e.g. English

# the 'bad' way:
$number = 1
$language = ''
if ($number -eq 1) {
    $language = "German"
}
elseif ($number -eq 2) {
    $language = "French"
}
elseif ($number -eq 3) {
    $language = "Spanish"
}
elseif ($number -eq 4) {
    $language = "Italian"
}
elseif ($number -eq 5) {
    $language = "Russian"
}
else {
    $language = "English"
}

# the 'ugly' way:
$number = 1
$language = switch ($number) {
    1 { "German" }
    2 { "French" }
    3 { "Spanish" }
    4 { "Italian" }
    5 { "Russian" }
    Default {"English"}
}

#the 'good' way:
$GetValueOrDefault = {
    param(
        $key,
        $defaultValue
    )
    $this.ContainsKey($key) ? $this[$key] : $defaultValue
}

$etd = @{
    TypeName = 'System.Collections.Hashtable'
    MemberType = 'Scriptmethod'
    MemberName = 'GetValueOrDefault'
    Value = $GetValueOrDefault
}
Update-TypeData @etd


$Number=1
$LanguageTable = @{
    1 = "German"
    2 = "French"
    3 = "Spanish"
    4 = "Italian"
    5 = "Russian"
}
$LanguageTable.GetValueOrDefault($Number,'English')