{
    $tb_Account = Get-PodeState -Name tb_Account

    $results = Get-AzDataTableEntity -Context $tb_Account | Select-Object Name, Basic, Apikey, OAuth, Quote, Experience, API, Environment
    Lock-PodeObject -Name Status -ScriptBlock {
        Set-PodeState -Name Status -Value $results
    }
}
