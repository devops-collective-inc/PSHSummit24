function Get-DynDnsZone {
    [CmdLetBinding()]
    param(
        [string]$Zone
    )

    if ($Zone) {
        $UriPath = "/REST/Zone/$Zone"
    } else {
        $UriPath = "/REST/Zone/"
    }

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $Zones = Invoke-DynDnsRequest -UriPath $UriPath
    Write-DynDnsOutput -DynDnsResponse $Zones -SkipSuccess
    if ($Zones.Data.status -eq 'failure') {
        return
    }

    if ($Zone) {
        Write-DynDnsOutput -DynDnsResponse $Zones
    } else {
        foreach ($UriPath in $Zones.Data.data) {
            $ZoneData = Invoke-DynDnsRequest -UriPath $UriPath
            Write-DynDnsOutput -DynDnsResponse $ZoneData
        }
    }
}