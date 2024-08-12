[CmdletBinding()]
param ( [Parameter(ValueFromPipeline=$true)][string]$inputObject )
BEGIN {
    $h = @{}
}

PROCESS {
    if ( $inputObject -match "^Mach Virtual") {
        if ($inputObject -match "page size of (\d+) ") {
            $h['PageSize'] = [int]$matches[1]
        }
    }
    else {
        $k,$v = $inputObject -split ":"
        $AdjustedK = ($k -replace "[ -]","_").trim() -replace '"'
        $AdjustedV = "$v".Trim() -replace "\.$"
        $h[$AdjustedK] = [int64]$AdjustedV
    }
}

END {
    [pscustomobject]$h
}