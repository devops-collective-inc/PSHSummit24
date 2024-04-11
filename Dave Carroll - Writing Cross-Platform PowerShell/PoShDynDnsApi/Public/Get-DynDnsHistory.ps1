function Get-DynDnsHistory {
    [CmdLetBinding(DefaultParameterSetName='Default')]
    [OutputType('DynDnsHistory')]
    param(
        [Parameter(ParameterSetName='Default')]
        [Parameter(ParameterSetName='Skip')]
        [Parameter(ParameterSetName='SkipLast')]
        [int]$First,
        [Parameter(ParameterSetName='Default')]
        [Parameter(ParameterSetName='Skip')]
        [Parameter(ParameterSetName='SkipLast')]
        [int]$Last,
        [Parameter(ParameterSetName='Skip')]
        [int]$Skip,
        [Parameter(ParameterSetName='SkipLast')]
        [int]$SkipLast
    )

    $DynDnsHistoryParms = @{}
    if ($First) {
        $DynDnsHistoryParms.Add('First',$First)
    }
    if ($Last) {
        $DynDnsHistoryParms.Add('Last',$Last)
    }
    if ($psCmdlet.ParameterSetName -eq 'Skip') {
        $DynDnsHistoryParms.Add('Skip',$Skip)
    }
    if ($psCmdlet.ParameterSetName -eq 'SkipLast') {
        $DynDnsHistoryParms.Add('SkipLast',$SkipLast)
    }

    $DynDnsHistoryList | Select-Object @DynDnsHistoryParms
}