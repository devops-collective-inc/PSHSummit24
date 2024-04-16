#---- Tip 7 - ParameterSets are great! (kinda)

function Get-StuffWithoutParameterSets {
    Param(
        [Parameter()]
        $ParamA,

        [Parameter()]
        $ParamB,

        [Parameter()]
        $ParamC,

        [Parameter()]
        $ParamD,

        [Parameter()]
        $ParamE,

        [Parameter()]
        $ParamF
    )

    Write-Host $PSBoundParameters
}
Clear-Host








function Get-StuffWithParameterSets {
    Param(
        [Parameter(ParameterSetName = 'a-c-e')]
        [Parameter(ParameterSetName = 'a-c-f')]
        [Parameter(ParameterSetName = 'a-d-e')]
        [Parameter(ParameterSetName = 'a-d-f')]
        $ParamA,

        [Parameter(ParameterSetName = 'b-c-e')]
        [Parameter(ParameterSetName = 'b-c-f')]
        [Parameter(ParameterSetName = 'b-d-e')]
        [Parameter(ParameterSetName = 'b-d-f')]
        $ParamB,

        [Parameter(ParameterSetName = 'a-c-e')]
        [Parameter(ParameterSetName = 'b-c-e')]
        [Parameter(ParameterSetName = 'a-c-f')]
        [Parameter(ParameterSetName = 'b-c-f')]
        $ParamC,

        [Parameter(ParameterSetName = 'a-d-e')]
        [Parameter(ParameterSetName = 'b-d-e')]
        [Parameter(ParameterSetName = 'a-d-f')]
        [Parameter(ParameterSetName = 'b-d-f')]
        $ParamD,

        [Parameter(ParameterSetName = 'a-c-e')]
        [Parameter(ParameterSetName = 'b-c-e')]
        [Parameter(ParameterSetName = 'a-d-e')]
        [Parameter(ParameterSetName = 'b-d-e')]
        $ParamE,

        [Parameter(ParameterSetName = 'a-c-f')]
        [Parameter(ParameterSetName = 'b-c-f')]
        [Parameter(ParameterSetName = 'a-d-f')]
        [Parameter(ParameterSetName = 'b-d-f')]
        $ParamF
    )

    Write-Host $PSBoundParameters
}
Clear-Host


