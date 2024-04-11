function Undo-DynDnsZoneChanges {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseSingularNouns','Discards all pending zone changes')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [switch]$Force
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $PendingZoneChanges = Get-DynDnsZoneChanges -Zone $Zone
    if ($PendingZoneChanges) {
        $PendingZoneChanges
    } else {
        Write-Warning -Message 'There are no pending zone changes.'
        if (-Not $Force) {
            return
        } else {
            Write-Verbose -Message '-Force switch used.'
        }
    }

    if ($PSCmdlet.ShouldProcess($Zone,"Discard zone changes")) {
        $UndoZoneChanges = Invoke-DynDnsRequest -UriPath "/REST/ZoneChanges/$Zone" -Method Delete
        Write-DynDnsOutput -DynDnsResponse $UndoZoneChanges
    } else {
        Write-Verbose 'Whatif : Discarded zone changes'
    }
}