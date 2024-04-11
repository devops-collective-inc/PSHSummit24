function Invoke-DynDnsRequestCore {
    [CmdLetBinding()]
    param(
        [Parameter(ParameterSetName='Default')]
        [ValidateSet('Get','Post','Put','Delete')]
        [System.Net.Http.HttpMethod]$Method='Get',

        [Parameter(ParameterSetName='Default')]
        [ValidateScript({$_ -match '^/REST/'})]
        [String]$UriPath,

        [Parameter(ParameterSetName='Default')]
        [Parameter(ParameterSetName='Session')]
        [Alias('JsonBody','Json')]
        [ValidateScript({$_ | ConvertFrom-Json})]
        [AllowNull()]
        $Body,

        [Parameter(ParameterSetName='Default')]
        [Switch]$SkipSessionCheck,

        [Parameter(ParameterSetName='Session')]
        [ValidateSet('Connect','Disconnect','Test','Send')]
        [string]$SessionAction
    )

    $EmptyBody = @{} | ConvertTo-Json
    $HttpClient = [System.Net.Http.Httpclient]::new()
    $HttpClient.Timeout = [System.TimeSpan]::new(0, 0, 90)
    $HttpClient.DefaultRequestHeaders.TransferEncodingChunked = $false
    $Accept = [System.Net.Http.Headers.MediaTypeWithQualityHeaderValue]::new('application/json')
    $HttpClient.DefaultRequestHeaders.Accept.Add($Accept)
    $HttpClient.BaseAddress = [Uri]$DynDnsSession.ClientUrl

    if ($PsCmdlet.ParameterSetName -eq 'Session') {
        $UriPath = '/REST/Session/'
        switch ($SessionAction) {
            'Connect'       {
                if ($Body) {
                    $HttpRequest = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post,$UriPath)
                    $HttpRequest.Content = [System.Net.Http.StringContent]::new($Body, [System.Text.Encoding]::UTF8, 'application/json')
                } else {
                    Write-Warning -Message 'No login credentials provided.'
                    return
                }
            }
            'Disconnect'    {
                if ($DynDnsSession.AuthToken) {
                    $HttpClient.DefaultRequestHeaders.Add('Auth-Token',$DynDnsSession.AuthToken)
                    $HttpRequest = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Delete,$UriPath)
                    $HttpRequest.Content = [System.Net.Http.StringContent]::new($EmptyBody, [System.Text.Encoding]::UTF8, 'application/json')
                } else {
                    Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
                    return
                }
            }
            'Send'          {
                if ($DynDnsSession.AuthToken) {
                    $HttpClient.DefaultRequestHeaders.Add('Auth-Token',$DynDnsSession.AuthToken)
                    $HttpRequest = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Put,$UriPath)
                    $HttpRequest.Content = [System.Net.Http.StringContent]::new($EmptyBody, [System.Text.Encoding]::UTF8, 'application/json')
                } else {
                    Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
                    return
                }
            }
            'Test'          {
                $HttpRequest = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Get,$UriPath)
                $HttpRequest.Content = [System.Net.Http.StringContent]::new($EmptyBody, [System.Text.Encoding]::UTF8, 'application/json')
                if ($DynDnsSession.AuthToken) {
                    $HttpClient.DefaultRequestHeaders.Add('Auth-Token',$DynDnsSession.AuthToken)
                } else {
                    Write-Verbose -Message 'No authentication token found.'
                    return
                }
            }
        }
    } else {
        if ($DynDnsSession.AuthToken) {
            $HttpClient.DefaultRequestHeaders.Add('Auth-Token',$DynDnsSession.AuthToken)
        } else {
            Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
            return
        }

        $HttpRequest = [System.Net.Http.HttpRequestMessage]::new($Method,$UriPath)
        if ($Body -and $Method -match 'Post|Put|Delete') {
            $HttpRequest.Content = [System.Net.Http.StringContent]::new($Body, [System.Text.Encoding]::UTF8, 'application/json')
        } else {
            $HttpRequest.Content = [System.Net.Http.StringContent]::new($EmptyBody, [System.Text.Encoding]::UTF8, 'application/json')
        }

    }

    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $HttpResponseMessage = $HttpClient.SendAsync($HttpRequest)
    if ($HttpResponseMessage.IsFaulted) {
        $PsCmdlet.ThrowTerminatingError($HttpResponseMessage.Exception)
    }
    $Result = $HttpResponseMessage.Result
    try {
        $Content = $Result.Content.ReadAsStringAsync().Result | ConvertFrom-Json
    }
    catch {
        $Content = $null
    }
    $ElapsedTime = $StopWatch.Elapsed.TotalSeconds
    $StopWatch.Stop()

    if ($SessionAction) {
        $ResponseBody = $null
    } else {
        $ResponseBody = $Body
    }

    $Response = [DynDnsHttpResponse]::New([PSCustomObject]@{
        Method            = $HttpRequest.Method.ToString().ToUpper()
        Body              = $ResponseBody
        Uri               = $HttpRequest.RequestUri.ToString()
        StatusCode        = $Result.StatusCode
        StatusDescription = $Result.ReasonPhrase
    })

    if ($Content.status -eq 'success') {
        $DynDnsSession.RefreshTime = [System.DateTime]::Now
    }

    [DynDnsRestResponse]::New(
        [PsCustomObject]@{
            Response    = $Response
            Data        = $Content
            ElapsedTime = $ElapsedTime
        }
    )

    $HttpClient.Dispose()

}