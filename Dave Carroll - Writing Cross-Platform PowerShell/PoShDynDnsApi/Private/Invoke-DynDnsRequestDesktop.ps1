function Invoke-DynDnsRequestDesktop {
    [CmdLetBinding()]
    param(
        [Parameter(ParameterSetName='Default')]
        [ValidateSet('Get','Post','Put','Delete')]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method='Get',

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

    $RestParams = @{
        ContentType = 'application/json'
        ErrorAction = 'Stop'
        Verbose = $false
    }

    if ($PsCmdlet.ParameterSetName -eq 'Session') {
        $RestParams.Add('Uri',"$($DynDnsSession.ClientUrl)/REST/Session/")
        switch ($SessionAction) {
            'Connect'       {
                $RestParams.Add('Method','Post')
                if ($Body) {
                    $RestParams.Add('Body',$Body)
                } else {
                    Write-Warning -Message 'No login credentials provided.'
                    return
                }
            }
            'Disconnect'    {
                $RestParams.Add('Method','Delete')
                if ($DynDnsSession.AuthToken) {
                    $RestParams.Add('Headers',@{'Auth-Token' = "$($DynDnsSession.AuthToken)"})
                } else {
                    Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
                    return
                }
            }
            'Send'          {
                $RestParams.Add('Method','Put')
                if ($DynDnsSession.AuthToken) {
                    $RestParams.Add('Headers',@{'Auth-Token' = "$($DynDnsSession.AuthToken)"})
                } else {
                    Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
                    return
                }
            }
            'Test'          {
                if ($DynDnsSession.AuthToken) {
                    $RestParams.Add('Method','Get')
                    $RestParams.Add('WarningAction','SilentlyContinue')
                    $RestParams.Add('Headers',@{'Auth-Token' = "$($DynDnsSession.AuthToken)"})
                } else {
                    Write-Verbose -Message 'No authentication token found.'
                    return
                }
            }
        }
    } else {
        if ($DynDnsSession.AuthToken) {
            $RestParams.Add('Headers',@{'Auth-Token' = "$($DynDnsSession.AuthToken)"})
        } else {
            Write-Warning -Message 'No authentication token found. Please use Connect-DynDnsSession to obtain a new token.'
            return
        }
        $RestParams.Add('Uri',"$($DynDnsSession.ClientUrl)$UriPath")
        $RestParams.Add('Method',$Method)
        if ($Body -and $Method -match 'Post|Put|Delete') {
            $RestParams.Add('Body',$Body)
        }
    }

    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $OriginalProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    try {
        $DynDnsResponse = Invoke-WebRequest @RestParams -ErrorVariable ErrorResponse
        $Content = $DynDnsResponse.Content
    }
    catch {
        $DynDnsResponse = $ErrorResponse.ErrorRecord.Exception.Response
        $ResponseReader = [System.IO.StreamReader]::new($DynDnsResponse.GetResponseStream())
        $Content = $ResponseReader.ReadToEnd()
        $ResponseReader.Close()
    }
    $ElapsedTime = $StopWatch.Elapsed.TotalSeconds
    $StopWatch.Stop()
    $ProgressPreference = $OriginalProgressPreference

    try {
        $Data = $Content | ConvertFrom-Json
    }
    catch {
        Write-Warning -Message 'Unable to convert response to JSON.'
        $Data = $null
    }

    if ($SessionAction) {
        $ResponseBody = $null
    } else {
        $ResponseBody = $Body
    }

    $Response = [DynDnsHttpResponse]::New([PSCustomObject]@{
        Method            = $RestParams.Method.ToString().ToUpper()
        Body              = $ResponseBody
        Uri               = $RestParams.Uri.ToString()
        StatusCode        = $DynDnsResponse.StatusCode
        StatusDescription = $DynDnsResponse.ReasonPhrase
    })

    if ($Data.status -eq 'success') {
        $DynDnsSession.RefreshTime = [System.DateTime]::Now
    }

    [DynDnsRestResponse]::New(
        [PsCustomObject]@{
            Response    = $Response
            Data        = $Data
            ElapsedTime = $ElapsedTime
        }
    )
}