
New-PodeAuthScheme -Form | Add-PodeAuth -Name 'Login' -FailureUrl '/login' -SuccessUseOrigin -ScriptBlock {
    param($username, $password)
    $tb_Account = Get-PodeState -Name tb_Account
    $account = Get-AzDataTableEntity -Context $tb_Account -Filter "RowKey eq '$username' and Password eq '$password'"
    if (-not $account) {
        Show-PodeWebToast "No account matched those creds. Please try again"
    }
    else {
        return @{ User = $account }
    }
}


New-PodeAuthScheme -Basic | Add-PodeAuth -Name 'Basic' -Sessionless -FailureUrl /401 -ScriptBlock {
    param($username, $password)
    $tb_Account = Get-PodeState -Name tb_Account
    $account = Get-AzDataTableEntity -Context $tb_Account -Filter "RowKey eq '$username' and Password eq '$password'"
    if (-not $account) {
        Write-PodeJsonResponse -Value "Error 401, no auth!" -StatusCode 401
    }
    else {
        return @{
            Headers = @{
                AuthenticationScheme = "Basic Auth"
            }
            User    = $account
        }
    }
}


New-PodeAuthScheme -ApiKey -Location Query | Add-PodeAuth -Name 'Key' -Sessionless -ScriptBlock {
    param($key)
    $tb_Account = Get-PodeState -Name tb_Account
    $account = Get-AzDataTableEntity -Context $tb_Account -Filter "Key eq '$key'" | Select-Object -First 1
    if (-not $account) {
        Write-PodeJsonResponse -Value "Error 401, no auth successful!" -StatusCode 401
    }
    else {
        return @{
            Headers = @{
                AuthenticationScheme = "API key"
            }
            User    = $account
        }
    }
}

New-PodeAuthScheme -Bearer | Add-PodeAuth -Name 'Bearer' -Sessionless -FailureUrl /401 -ScriptBlock {
    param($Token)
    $tb_Account = Get-PodeState -Name tb_Account
    $account = Get-AzDataTableEntity -Context $tb_Account -Filter "Bearer eq '$Token'" | Select-Object -First 1
    if (-not $account) {
        Write-PodeJsonResponse -Value "Error 401, no auth successfully done!" -StatusCode 401
    }
    else {
        return @{
            Headers = @{
                AuthenticationScheme = "BearerToken"
            }
            User    = $account
        }
    }
}

