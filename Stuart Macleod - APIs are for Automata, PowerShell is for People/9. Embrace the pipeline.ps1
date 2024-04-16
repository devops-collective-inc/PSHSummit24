#---- Tip 9 - Embrace the pipeline. Beware the pipeline

$Config = Get-Config -Name MyConfig -Version Latest -Status enabled
$Config.Name = 'MyNewConfig'
$Config | Set-Config -Name MyConfig -Version Latest -Status enabled

function Set-Config {
    Param(
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        $Version,
        [Parameter(Mandatory)]
        $Status,
        [Parameter(Mandatory, ValueFromPipeline)]
        $MyConfig
    )

    process {
        $RequestObj = [PSCustomObject]@{
            operation = 'replace'
            config    = $MyConfigObj
        }
        
        $IRMParams = @{
            Uri    = 'https://api.example.com/api/configs/'
            Method = 'POST'
            Body   = ($RequestObj | ConvertTo-Json)
        }
        
        $Result = Invoke-RestMethod @IRMParams
        return $Result
    }
}





function Set-PipedArray {
    Param(
        [Parameter(ValueFromPipeline)]
        $InputArray
    )

    begin {
        $OutputArray = @()
    }
    process {
        $OutputArray += $InputArray
    }
    end {
        $IRMParams = @{
            Uri  = "http://api.example.com/update"
            Body = ($OutputArray | ConvertTo-Json -AsArray)
        }
        $Result = Invoke-RestMethod @IRMParams
        return $Result
    }
}
