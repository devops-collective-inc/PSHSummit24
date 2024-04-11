$endpoint_param = @{
    Address  = "0.0.0.0"
    Port     = 80
    Protocol = "Http"
    Name     = "User"
}

if ($ENV:LISTENING_ADDRESS) {
    $endpoint_param.Address = $ENV:LISTENING_ADDRESS
}
if ($ENV:PORT) {
    $endpoint_param.Port = $ENV:PORT
}
if ($ENV:PROTOCOL) {
    $endpoint_param.Protocol = $ENV:PROTOCOL
}
if ($ENV:CONTAINER_HOSTNAME) {
    $endpoint_param.Hostname = $ENV:CONTAINER_HOSTNAME
}
Set-PodeState -Name endpoint_param -Value $endpoint_param
Add-PodeEndpoint @endpoint_param

switch ($ENV:RUN_MODE) {
    'create' {
        $create = $true
    }
    'remove' {
        $remove = $true
    }
    'redeploy' {
        $redeploy = $true
    }
}

if ($ENV:STORAGE_PASSPHRASE) { $storage_passphrase = $ENV:STORAGE_PASSPHRASE }
else {
    Write-Warning "Using random guid as storage passphrase"
    $storage_passphrase = (New-Guid) -as [string]
}

Enable-PodeSessionMiddleware -Duration ([int]::MaxValue) -Secret $storage_passphrase -Storage $sessionHost

'Account', 'Session' | ForEach-Object {
    if ($ENV:TABLE_STORE -match "AccountKey") {
        $var = New-AzDataTableContext -TableName $_ -ConnectionString $ENV:TABLE_STORE
    }
    elseif ($ENV:TABLE_STORE -match "devstoreaccount1") {
        $var = New-AzDataTableContext -SharedAccessSignature $ENV:TABLE_STORE -TableName $_
    }
    else {
        throw "No storage connection found"
    }
    Set-Variable -Name "tb_$_" -Value $var
    Set-PodeState -Name "tb_$_" -Value $var
    if ($remove) {
        Remove-AzDataTable -Context $var
        "default- Removing table $_" | Out-Default
        if ($ENV:REMOVE_DELAY) {
            Start-Sleep $ENV:REMOVE_DELAY
        }
    }
    if ($redeploy -and $_ -ne "Session") {
        Clear-AzDataTable -Context $var
    }

    if ($create) {
        # "write- Adding table $_" | Write-Host
        "default- Adding table $_" | Out-Default
        for ($i = 0; $i -lt 5; $i++) {
            try {
                New-AzDataTable -Context $var -ea stop
                $i = 10
            }
            catch {
                Write-Warning "Table not created this time on try $i"
                Start-Sleep 10
            }
        }
        if ($i -lt 10) {
            throw "Unable to create table $_ after $i attempts"
        }
    }
}

Set-PodeState -Name cache_Sessions -Value @{}


# Add-PodeEndpoint -Address localhost -Port 8080 -Protocol Http -Name User
# Add-PodeEndpoint -Address '[::1]' -Port 8080 -Protocol Http -Name User
# New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging

Use-PodeWebTemplates -Title 'DevOps Summit' -Theme Light -EndpointName User -NoPageFilter

Add-PodeSchedule -Name 'Status' -Cron '@minutely' -FilePath './schedules/status.ps1' -OnStart

