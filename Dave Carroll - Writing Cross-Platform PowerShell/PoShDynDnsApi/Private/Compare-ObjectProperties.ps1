# https://blogs.technet.microsoft.com/janesays/2017/04/25/compare-all-properties-of-two-objects-in-windows-powershell/
function Compare-ObjectProperties {
    [CmdLetBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseSingularNouns', Justification='Compares all properties')]
    Param(
        [PSObject]$ReferenceObject,
        [PSObject]$DifferenceObject
    )
    $objprops = $ReferenceObject | Get-Member -MemberType Property,NoteProperty | ForEach-Object Name
    $objprops += $DifferenceObject | Get-Member -MemberType Property,NoteProperty | ForEach-Object Name
    $objprops = $objprops | Sort-Object | Select-Object -Unique
    $diffs = @()
    foreach ($objprop in $objprops) {
        $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop
        if ($diff) {
            $diffprops = @{
                PropertyName=$objprop
                RefValue=($diff | Where-Object {$_.SideIndicator -eq '<='} | ForEach-Object $($objprop) )
                DiffValue=($diff | Where-Object {$_.SideIndicator -eq '=>'} | ForEach-Object $($objprop))
            }
            $diffs += New-Object PSObject -Property $diffprops
        }
    }
    if ($diffs) {return ($diffs | Select-Object PropertyName,RefValue,DiffValue)}
}