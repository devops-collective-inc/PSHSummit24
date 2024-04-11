$sessionHost = [PSCustomObject]@{
    Get    = {
        param($sessionId)
        # "Get session $sessionId" | Out-Default
        $cache_Sessions = Get-PodeState cache_Sessions
        if ($obj = $cache_Sessions[$sessionId]) {}
        else {
            "Cache miss: $sessionId" | Out-Default
            $tb_Session = Get-PodeState tb_Session
            $partitionKey = $sessionId.Substring(0, 1)
            $obj = Get-AzDataTableEntity -Context $tb_Session -Filter "PartitionKey eq '$partitionKey' and RowKey eq '$sessionId'"
        }
        if (-not $obj) { return }
        elseif ($obj.Expiry -lt [datetime]::UtcNow) {
            "Expired session: {0}" -f $obj.Expiry | Out-Default
            return
        }

        if (-not $cache_Sessions[$sessionId]) {
            # "Writing to cache: $sessionId" | Out-Default
            $cache_Sessions[$sessionId] = $obj
            Set-PodeState -Name cache_Sessions -Value $cache_Sessions
        }

        $session = $obj.Value | ConvertFrom-Json -AsHashtable
        # See issue #1231 about User NEEDING to be a PSCO.
        try { $session.Data.Auth.User = [PSCustomObject]$session.Data.Auth.User }
        catch {}
        $session
    }
    Set    = {
        param($sessionId, $data, $expiry)
        # "SET session $sessionId" | Out-Default
        $tb_Session = Get-PodeState tb_Session
        $partitionKey = $sessionId.Substring(0, 1)
        $obj = @{
            PartitionKey = $partitionKey
            RowKey       = "$sessionId"
            Value        = ($data | ConvertTo-Json -Compress -Depth 10) -as [string]
            Expiry       = $expiry -as [System.DateTimeOffset]
        }
        # "Upsert" | Out-Default
        $cache_Sessions = Get-PodeState cache_Sessions
        $cache_Sessions[$sessionId] = $obj
        Set-PodeState -Name cache_Sessions -Value $cache_Sessions
        Add-AzDataTableEntity -Context $tb_Session -Entity $obj -Force
    }
    Delete = {
        param($sessionId)
        "DELETE session $sessionId" | Out-Default
        $tb_Session = Get-PodeState tb_Session
        $partitionKey = $sessionId.Substring(0, 1)
        Remove-AzDataTableEntity -Context $tb_Session -Entity @{
            PartitionKey = $partitionKey
            RowKey       = $sessionId
        }
        try {
            $cache_Sessions = Get-PodeState cache_Sessions
            $cache_Sessions.Remove($sessionId)
        }
        catch {
            "Could not remove $sessionId" | Write-Warning
        }
    }
}
