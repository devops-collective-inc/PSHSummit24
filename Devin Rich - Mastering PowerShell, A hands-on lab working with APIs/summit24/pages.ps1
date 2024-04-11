
Set-PodeWebLoginPage -Authentication Login -Content @(
    New-PodeWebTextbox -Name Username -Placeholder username -NoForm -Required -CssStyle @{"margin-bottom" = "15px" ; "line-height" = "24px"; color = "#999" }
    New-PodeWebTextbox -Name Password -Type Password -Placeholder password -NoForm -Required -CssStyle @{"margin-bottom" = "15px" ; "line-height" = "24px"; color = "#999" }
    New-PodeWebButton -Name 'Create Account' -CssStyle @{"width" = "100%"; "margin-bottom" = "15px" ; "font-size" = "1.25rem"; "line-height" = "1.5"; "background-color" = "#004488" } -ScriptBlock {
        Move-PodeWebUrl -Url /pages/register
    }
)


Set-PodeWebHomePage -DisplayName Homepage -Title Homepage -Layouts @(
    New-PodeWebHero -Title 'Welcome!' -Message 'This is the home page' -Content @(
        New-PodeWebText -Value 'Use the links in the nav sidebar to access other pages.' -InParagraph
        New-PodeWebText -Value "This playground will be used for part of today's lab." -InParagraph
    )
)




Add-PodeWebPage -Name Status -NoAuthentication -Icon numeric -ScriptBlock {
    New-PodeWebCard -NoHide -CssStyle @{"max-width" = "800px" } -Name "Calls so far..." -Content @(
        New-PodeWebTable -Name 'Status' -ScriptBlock {
            $results = Get-PodeState -Name Status | Select-Object Name, Basic, ApiKey, OAuth, Quote
            if ($WebEvent.Data.Filter) {
                $results = $results | Where-Object { $_ -match $WebEvent.Data.Filter }
            }
            if ($WebEvent.Data.SortColumn) {
                if ($WebEvent.Data.SortColumn -eq "Score") { $WebEvent.Data.SortColumn = "Timespan" }
                $descending = ($WebEvent.Data.SortDirection -ieq 'desc')
                $results = $results | Sort-Object $WebEvent.Data.SortColumn -Descending:$descending
            }
            $results | Select-Object *
        } -PageSize 20 -Paginate -Filter -Compact -Sort
    )
    New-PodeWebButton -Name 'Update Calls' -ScriptBlock {
        Invoke-PodeSchedule -Name Status
        Start-Sleep 1
        Move-PodeWebPage -Name Status
    }
}


Add-PodeWebPageLink -Name Clippy -Url 'https://doc.dcrich.net/v_A2VyI6TR6kw1vIZcDjQA?view' -Icon 'Clipboard' -NewTab
Add-PodeWebPageLink -Name Documentation -Url 'https://app.swaggerhub.com/apis-docs/SZERAAXSWAGGERHUB/summit-lab' -Icon 'file-document-outline' -NewTab

Add-PodeWebPage -Name Demographics -NoAuthentication -Icon account-group -ScriptBlock {
    New-PodeWebCard -NoHide -CssStyle @{"max-width" = "500px" } -Name "PowerShell Experience Level" -Content @(
        New-PodeWebChart -Name 'PowerShell Experience Level' -Type Bar -NoRefresh -ScriptBlock {
            $results = Get-PodeState -Name Status
            $results |
            Select-Object -expand Experience |
            Group-Object |
            ConvertTo-PodeWebChartData -LabelProperty Name -DatasetProperty Count
        }
    )
    New-PodeWebCard -NoHide -CssStyle @{"max-width" = "500px" } -Name "API Experience Level" -Content @(
        New-PodeWebChart -Name 'API Experience Level' -Type Bar -NoRefresh -ScriptBlock {
            $results = Get-PodeState -Name Status
            $results |
            Select-Object -expand API |
            Group-Object |
            ConvertTo-PodeWebChartData -LabelProperty Name -DatasetProperty Count
        }
    )
    New-PodeWebCard -NoHide -CssStyle @{"max-width" = "500px" } -Name "Environment" -Content @(
        New-PodeWebChart -Name 'Environment' -Type Bar -NoRefresh -ScriptBlock {
            $results = Get-PodeState -Name Status
            $results |
            Select-Object -expand Environment |
            Group-Object |
            ConvertTo-PodeWebChartData -LabelProperty Name -DatasetProperty Count
        }
    )
    New-PodeWebButton -Name 'Update Demographics' -ScriptBlock {
        Invoke-PodeSchedule -Name Status
        Start-Sleep 1
        Move-PodeWebPage -Name Demographics
    }
}


Add-PodeWebPage -Name 'Request' -Icon bug-check -NoAuthentication -ScriptBlock {
    New-PodeWebCard -Content @(
        $data = $WebEvent.Request.Headers | ConvertTo-Json
        $data -split "`n" | ForEach-Object { New-PodeWebParagraph -Value $_ }
    )
}

Add-PodeWebPage -Name 'API Creds' -Title "API Creds!" -Icon shield-account -ScriptBlock {
    New-PodeWebCard -Content @(
        New-PodeWebCheckbox -Name KeyTextbox -DisplayName 'Show API key' -AsSwitch | Register-PodeWebEvent -Type Change -ScriptBlock {
            If ($WebEvent.Data['KeyTextbox']) { Show-PodeWebComponent -Id Key }
            Else { Hide-PodeWebComponent -Id Key }
        }
        New-PodeWebTextbox -Name "API key" -ReadOnly -Value $WebEvent.Auth.User.Key -Id Key -PrependIcon lock -CssStyle @{Display = 'None' }
    ) -NoHide -CssStyle @{"max-width" = "800px" }

    New-PodeWebCard -Content @(
        New-PodeWebCheckbox -Name BearerTextbox -DisplayName 'Show bearer token' -AsSwitch | Register-PodeWebEvent -Type Change -ScriptBlock {
            If ($WebEvent.Data['BearerTextbox']) { Show-PodeWebComponent -Id token }
            Else { Hide-PodeWebComponent -Id token }
        }
        New-PodeWebTextbox -Name "Bearer token" -ReadOnly -Value $WebEvent.Auth.User.Bearer -Id token -PrependIcon lock -CssStyle @{Display = 'None' }
    ) -NoHide -CssStyle @{"max-width" = "800px" }
}

