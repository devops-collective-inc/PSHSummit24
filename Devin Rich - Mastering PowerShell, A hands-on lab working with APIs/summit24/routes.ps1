Add-PodeRoute -Path /api/statusCode/:statusCode -Method Get -ScriptBlock {
    Add-PodeHeader -Name "retry-after" -Value 1
    Write-PodeHtmlResponse -StatusCode $WebEvent.Parameters.statusCode -Value ""
}

Add-PodeRoute -Path /api/dinosaur -Method Get -ScriptBlock {
    Write-PodeJsonResponse -Value "You see a graveyard, lost to time and without acclaim."
}
Add-PodeRoute -Path /api/dinosaur -Method Post -ScriptBlock {
    Write-PodeJsonResponse -StatusCode 500 -Value "Not yet ready! Hopefully less than 65MM more years. #WorkingOnIt #SadWorkNoises"
}

Add-PodeRoute -Path /api/request -Method Post, Put, Get, Delete, Patch -ScriptBlock {
    Write-PodeJsonResponse ($WebEvent.Request | Select-Object Url, HttpMethod, Body, Headers, QueryString)
}

Add-PodeRoute -Path /api/account -Method Get -ScriptBlock {
    $results = Get-PodeState -Name Status | Select-Object Name, Basic, ApiKey, OAuth, Quote

    if ($WebEvent.Query.Filter) {
        $results = $results | Where-Object { $_ -match $WebEvent.Query.Filter }
    }
    $total = $results.count
    if ($WebEvent.Query.OrderBy) {
        $descending = 'True' -eq $WebEvent.Query.SortDesc
        $results = $results | Sort-Object $WebEvent.Query.OrderBy -Descending:$descending
    }
    $pagesize = $WebEvent.Query.PageSize ? $WebEvent.Query.PageSize : 5
    $page = $WebEvent.Query.Page -as [int] ? $WebEvent.Query.Page -as [int] : 1

    $results = $results | Select-Object -Skip (($page - 1) * $pagesize)
    $selected = $results | Select-Object -First $pagesize

    Write-PodeJsonResponse @{
        totalcount = $total
        count      = $selected.count
        next       = $selected.count -ne $results.count ? $page + 1 : $null
        data       = $selected
    }
}

$apiUsersGet_param = @{
    Path           = '/api/user_password'
    Method         = 'Get'
    Authentication = 'Basic'
    ScriptBlock    = {
        $tb_Account = Get-PodeState -Name tb_Account
        Update-AzDataTableEntity -Context $tb_Account -Entity @{
            PartitionKey = ''
            RowKey       = $WebEvent.Auth.User.Username
            Basic        = [int]$WebEvent.Auth.User.Basic + 1
        }
        Write-PodeJsonResponse -Value "Congratz $($WebEvent.Auth.User.Username) ($($WebEvent.Auth.User.Name)). You authenticated via basic auth!"
    }
}
Add-PodeRoute @apiUsersGet_param

$apiUsersGet_param = @{
    Path           = '/api/user_key'
    Method         = 'Get'
    Authentication = 'Key'
    ScriptBlock    = {
        $tb_Account = Get-PodeState -Name tb_Account
        Update-AzDataTableEntity -Context $tb_Account -Entity @{
            PartitionKey = ''
            RowKey       = $WebEvent.Auth.User.Username
            ApiKey       = [int]$WebEvent.Auth.User.ApiKey + 1
        }
        Write-PodeJsonResponse -Value "Congratz $($WebEvent.Auth.User.Username) ($($WebEvent.Auth.User.Name)). You authenticated via key auth!"
    }
}
Add-PodeRoute @apiUsersGet_param

$apiUsersGet_param = @{
    Path           = '/api/user_bearer'
    Method         = 'Get'
    Authentication = 'Bearer'
    ScriptBlock    = {
        $tb_Account = Get-PodeState -Name tb_Account
        Update-AzDataTableEntity -Context $tb_Account -Entity @{
            PartitionKey = ''
            RowKey       = $WebEvent.Auth.User.Username
            OAuth        = [int]$WebEvent.Auth.User.OAuth + 1
        }
        Write-PodeJsonResponse -Value "Congratz $($WebEvent.Auth.User.Username) ($($WebEvent.Auth.User.Name)). You authenticated via bearer auth!" }
}
Add-PodeRoute @apiUsersGet_param

Add-PodeRoute -Authentication Key -Path /api/quote -Method Get -ScriptBlock {
    try {
        $data = Invoke-RestMethod "https://ron-swanson-quotes.herokuapp.com/v2/quotes" -TimeoutSec 1
        $tb_Account = Get-PodeState -Name tb_Account
        Update-AzDataTableEntity -Context $tb_Account -Entity @{
            PartitionKey = ''
            RowKey       = $WebEvent.Auth.User.Username
            Quote        = [int]$WebEvent.Auth.User.Quote + 1
        }
        Write-PodeJsonResponse -StatusCode 200 -Value $data[0]
    }
    catch {
        Write-PodeJsonResponse -StatusCode 504 -Value @{
            message = "Resource is booting up. Please wait!"
        }
    }
}
