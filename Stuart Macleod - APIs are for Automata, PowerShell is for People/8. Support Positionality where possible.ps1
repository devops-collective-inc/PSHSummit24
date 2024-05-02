#---- Tip 8 - Support Positional Parameters where possible

function Invoke-Simple($a, $b, $c) {
    Write-Host $PSBoundParameters
}
Clear-Host
Get-Help Invoke-Simple






function Invoke-MoreComplex {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]
        $a,
        [Parameter()]
        [string]
        $b,
        [Parameter()]
        [string]
        $c
    )
    Write-Host $PSBoundParameters
}
Clear-Host
Get-Help Invoke-MoreComplex




function Invoke-WithParameterSets {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param(
        [Parameter(ParameterSetName = '1')]
        [string]
        $a1,
        [Parameter(ParameterSetName = '2')]
        [string]
        $a2,
        [Parameter()]
        [string]
        $b,
        [Parameter()]
        [string]
        $c
    )
    Write-Host $PSBoundParameters
}
Clear-Host

Get-Help Invoke-Simple -Parameter b
Get-Help Invoke-WithParameterSets -Parameter b





function Invoke-WithPosition {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = '1', Position = 0)]
        [string]
        $a1,
        [Parameter(ParameterSetName = '2')]
        [string]
        $a2,
        [Parameter(Position = 1)]
        [string]
        $b,
        [Parameter(Position = 2)]
        [string]
        $c
    )
    Write-Host $PSBoundParameters
}
Clear-Host



