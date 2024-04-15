function Get-DynDnsZoneNotes {
    [CmdLetBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseSingularNouns','Retrieves zone notes')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [ValidateRange(1,1000)]
        [int]$Limit = 1000,
        [ValidateRange(0,1000)]
        [int]$Offset = 0
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $JsonBody = @{
        zone = $Zone
        limit = $Limit
        offset = $Offset
    } | ConvertTo-Json

    $ZoneNotes = Invoke-DynDnsRequest -UriPath "/REST/ZoneNoteReport" -Method Post -Body $JsonBody
    Write-DynDnsOutput -DynDnsResponse $ZoneNotes
}