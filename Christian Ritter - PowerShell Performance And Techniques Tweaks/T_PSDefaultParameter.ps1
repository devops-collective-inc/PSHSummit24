#region example

#region example of a long commandlet which is hard to read and will be re-occure every time you run need to make a call to the api
Invoke-RestMethod -Uri "https://api.example.com/resource" -Method POST -Headers @{
    'Authorization' = 'Bearer YourAccessToken'
    'Content-Type'  = 'application/json'
} -Body @{
    'key1'   = 'value1'
    'key2'   = 'value2'
    'nested' = @{
        'nestedKey1' = 'nestedValue1'
        'nestedKey2' = 'nestedValue2'
    }
} -TimeoutSec 30 -Proxy "http://proxy.example.com:8080" -UseBasicParsing -SessionVariable $session -DisableKeepAlive -SkipCertificateCheck -MaximumRedirection 0 -MaximumRetryCount 0 -ProxyCredential $Creds -ProxyUseDefaultCredentials  -ProxyAuthentication Negotiate -TransferEncoding Chunked -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36" -ContentType "application/json" -PassThru

#endregion

#region Solution: Use splatting to make the command more readable and easier to maintain

$invokeRestMethodSplat = @{
    Uri = "https://api.example.com/resource"
    Method = 'POST'
    TimeoutSec = 30
    Proxy = "http://proxy.example.com:8080"
    UseBasicParsing = $true
    SessionVariable = $session
    DisableKeepAlive = $true
    SkipCertificateCheck = $true
    MaximumRedirection = 0
    MaximumRetryCount = 0
    ProxyCredential = $Creds
    ProxyUseDefaultCredentials = $true
    TransferEncoding = 'Chunked'
    UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36"
    ContentType = "application/json"
    PassThru = $true
    ProxyAuthentication = 'Negotiate'
    Headers = @{
        'Authorization' = 'Bearer YourAccessToken'
        'Content-Type'  = 'application/json'
    }
}

Invoke-RestMethod @invokeRestMethodSplat -Body @{
    'key1'   = 'value1'
    'key2'   = 'value2'
    'nested' = @{
        'nestedKey1' = 'nestedValue1'
        'nestedKey2' = 'nestedValue2'
    }
}

#endregion

#region better solution >>in this case<< : make us of $PSDefaultParameterValues
$PSDefaultParameterValues = @{
    
    'Invoke-RestMethod:Method' = 'POST'
    'Invoke-RestMethod:TimeoutSec' = 30
    'Invoke-RestMethod:Proxy' = "http://proxy.example.com:8080"
    'Invoke-RestMethod:UseBasicParsing' = $true
    'Invoke-RestMethod:SessionVariable' = $session
    'Invoke-RestMethod:DisableKeepAlive' = $true
    'Invoke-RestMethod:SkipCertificateCheck' = $true
    'Invoke-RestMethod:MaximumRedirection' = 0
    'Invoke-RestMethod:MaximumRetryCount' = 0
    'Invoke-RestMethod:ProxyCredential' = $Creds
    'Invoke-RestMethod:ProxyUseDefaultCredentials' = $true
    'Invoke-RestMethod:TransferEncoding' = 'Chunked'
    'Invoke-RestMethod:UserAgent' = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36"
    'Invoke-RestMethod:ContentType' = "application/json"
    'Invoke-RestMethod:PassThru' = $true
    'Invoke-RestMethod:ProxyAuthentication' = 'Negotiate'
    'Invoke-RestMethod:Header' = @{
        'Authorization' = 'Bearer YourAccessToken'
        'Content-Type'  = 'application/json'
    }
}

Invoke-Restmethod -Body @{
    'key1'   = 'value1'
    'key2'   = 'value2'
    'nested' = @{
        'nestedKey1' = 'nestedValue1'
        'nestedKey2' = 'nestedValue2'
    }
} -Uri = "https://api.example.com/resource"

#endregion

#region Handy note:

#you can use $PSDefaultParameterValues to set default values for any cmdlet even with wildcards
$PSDefaultParameterValues = @{
    'Invoke-*:Header' =  @{
        'Authorization' = 'Bearer YourAccessToken'
        'Content-Type'  = 'application/json'
    }
}
#this works now for Invoke-RestMethod as well as Invoke-WebRequest, WARNING: this will also work for Invoke-Command, be careful

#endregion

#endregion

#region Simple demo example
$PSDefaultParameterValues = @{
    "Install-Module:Scope"        = "CurrentUser"
    "Install-Module:AllowClobber" = $true
}
$PSDefaultParameterValues.Add("Export-Csv:NoTypeInformation", $true)
#endregion