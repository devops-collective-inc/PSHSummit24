function Publish-DynDnsZoneChanges {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [string]$Notes,
        [switch]$Force
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $PendingZoneChanges = Get-DynDnsZoneChanges -Zone $Zone
    if ($PendingZoneChanges) {
        Write-Verbose -Message ($PendingZoneChanges | Out-String).Trim()
    } else {
        Write-Warning -Message 'There are no pending zone changes.'
        if (-Not $Force) {
            return
        } else {
            Write-Verbose -Message '-Force switch used.'
        }
    }

    if ($Notes) {
        $BodyNotes = "REST-Api-PoSh: $Notes"
    } else {
        $BodyNotes = 'REST-Api-PoSh'
    }

    $JsonBody = @{
        publish = $true
        notes = $BodyNotes
    } | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess($Zone,"Publish zone changes")) {
        $PublishZoneChanges = Invoke-DynDnsRequest -UriPath "/REST/Zone/$Zone" -Method Put -Body $JsonBody
        ''
        Write-DynDnsOutput -DynDnsResponse $PublishZoneChanges
    } else {
        Write-Verbose 'Whatif : Published zone changes'
    }
}