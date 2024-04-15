function Write-DynDnsOutput {
    [CmdLetBinding()]
    param(
        [PsObject]$DynDnsResponse,
        [switch]$SkipSuccess
    )

    if ($DynDnsSession.ApiVersion) {
        $ApiVersion = 'API-' + $DynDnsSession.ApiVersion
    } else {
        $ApiVersion = $null
    }

    $Status = $JobId = $null
    if ($null -ne $DynDnsResponse.Data.status) {
        $Status = $DynDnsResponse.Data.status
    }
    if ($null -ne $DynDnsResponse.Data.job_id) {
        $JobId = $DynDnsResponse.Data.job_id
    }

    $MyFunction = Get-PSCallStack | Where-Object {$_.Command -notmatch 'DynDnsRequest|DynDnsOutput|ScriptBlock'}

    if ($MyFunction.Arguments) {
        $Arguments = $MyFunction.Arguments -Split ',' | Sort-Object -Unique | ForEach-Object {
            if ($_ -match '\w+=\S+\w+') { $matches[0] } } | Where-Object {
                $_ -notmatch 'Debug|Verbose|InformationAction|WarningAction|ErrorAction|Variable|null'
            }
        $Arguments = $Arguments | ForEach-Object { $_.Replace('\','\\') | ConvertFrom-StringData }
    }

    if ($DynDnsResponse.Response.Uri -match 'Session') {
        $Command = $MyFunction.Command | Where-Object { $_ -match 'DynDnsSession' } | Select-Object -First 1
        $FilteredArguments = @{}
    } else {
        $MyFunction = $MyFunction | Select-Object -First 1
        $Command = $MyFunction.Command

        if ($MyFunction.Arguments) {
            $Arguments = $MyFunction.Arguments -Split ',' | Sort-Object -Unique | ForEach-Object {
                if ($_ -match '\w+=\S+\w+') { $matches[0] } } | Where-Object {
                    $_ -notmatch 'Debug|Verbose|InformationAction|WarningAction|ErrorAction|Variable'
                }
            $Arguments = $Arguments | ForEach-Object { $_.Replace('\','\\') | ConvertFrom-StringData }

            $FilteredArguments = @{}
            foreach ($Key in ($Arguments.Keys | Sort-Object -Unique)) {
                $FilteredArguments.Add($Key,$Arguments.$Key.Replace('$null',''))
            }
        }
    }

    $InformationOutput = [DynDnsHistory]::New(@{
        Command = $Command
        Status = $Status
        JobId = $JobId
        Method = $DynDnsResponse.Response.Method
        Uri = $DynDnsResponse.Response.Uri
        Body = $DynDnsResponse.Response.Body
        StatusCode = $DynDnsResponse.Response.StatusCode
        StatusDescription = $DynDnsResponse.Response.StatusDescription
        ElapsedTime = "{0:N3}" -f $DynDnsResponse.ElapsedTime
        Arguments = $FilteredArguments
    })

    if ($InformationOutput.StatusCode) {
        $DynDnsHistoryList.Add($InformationOutput)
        Write-Information -MessageData $InformationOutput
    } else {
        Write-Warning -Message 'No StatusCode returned.'
    }

    switch ($Command) {
        'Add-DynDnsZone' {
            foreach ($Info in $Message.INFO) {
                ($Info -Split (':',2))[1].Trim()
            }
        }
        'Publish-DynDnsZoneChanges' {
            if ($DynDnsResponse.Data.msgs.INFO -match 'Missing SOA record' ) {
                'The attempt to import {0} has failed. Please delete the zone and reattempt the import after fixing errors.' -f $DynDnsResponse.Response.Uri.Split('/')[-1]
            }
        }
    }

    foreach ($Message in $DynDnsResponse.Data.msgs) {
        $VerboseMessage = ($ApiVersion,$Message.LVL,$Message.SOURCE,$Message.INFO -join ' : ')
        $ErrorMessage = ($ApiVersion,$Message.LVL,$Message.SOURCE,$Message.ERR_CD,$Message.INFO -join ' : ')
        switch ($Message.LVL) {
            'INFO' {
                Write-Verbose -Message $VerboseMessage
            }
            'ERROR' {
                if ($Message.ERR_CD -eq 'NOT_FOUND' -and $Message.INFO -notlike '*No such zone') {
                    Write-Verbose -Message $ErrorMessage
                } else {
                    Write-Warning -Message $ErrorMessage
                }
            }
            default {
                Write-Warning -Message $ErrorMessage
            }
        }
    }

    if ($SkipSuccess) {
        return
    }

    if ($Status -eq 'success') {
        foreach ($DataResponse in $DynDnsResponse.Data.data) {
            if ($Command -notmatch 'Remove|Undo') {
                switch ($Command.Split('-')[1]) {
                    'DynDnsRecord' {
                        switch ($DataResponse.record_type) {
                            'A'     { [DynDnsRecord_A]::New($DataResponse) }
                            'TXT'   { [DynDnsRecord_TXT]::New($DataResponse) }
                            'CNAME' { [DynDnsRecord_CNAME]::New($DataResponse) }
                            'MX'    { [DynDnsRecord_MX]::New($DataResponse) }
                            'SRV'   { [DynDnsRecord_SRV]::New($DataResponse) }
                            'NS'    { [DynDnsRecord_NS]::New($DataResponse) }
                            'PTR'   { [DynDnsRecord_PTR]::New($DataResponse) }
                            'SOA'   { [DynDnsRecord_SOA]::New($DataResponse) }
                            default {
                                [DynDnsRecord]::New($DataResponse)
                            }
                        }
                    }
                    'DynDnsZone' {
                        [DynDnsZone]::New($DataResponse)
                    }
                    'DynDnsTask' {
                        [DynDnsTask]::New($DataResponse)
                    }
                    'DynDnsZoneNotes' {
                        [DynDnsZoneNote]::New($DataResponse)
                    }
                    'DynDnsHttpRedirect' {
                        [DynDnsHttpRedirect]::New($DataResponse)
                    }
                    'DynDnsUser' {
                        [DynDnsUser]::New($DataResponse)
                    }
                    'DynDnsZoneChanges' {
                        [DynDnsZoneChanges]::New($DataResponse)
                    }
                    'DynDnsSession' {
                        return
                    }
                    default {
                        $DataResponse
                    }
                }
            }
        }
    }
}