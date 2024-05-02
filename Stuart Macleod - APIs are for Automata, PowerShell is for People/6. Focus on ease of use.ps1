#---- Tip 6 - Focus on ease of use

function Get-Thing {
    Param(
        [Parameter(ParameterSetName = 'name')]
        [string]
        $FriendlyName,

        [Parameter(ParameterSetName = 'id')]
        [string]
        $UnfriendlyID,

        [Parameter()]
        [string]
        $Version,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [string]
        $Status
    )

    if ($FriendlyName) {
        $AllThings = Get-Thing
        $UnfriendlyID = ($AllThings | Where-Object name -eq $FriendlyName).ID
    }
    if ($Version -eq 'latest') {
        $AllVersions = Get-ThingVersions
        $Version = ($AllVersions | Sort-Object -Property Version -Descending ) | Select-Object -First 1
    }

    $URI = "https://api.example.com/api/things/$UnfriendlyID/versions/$Version`?status=$Status"
    try {
        $Result = Invoke-RestMethod -Uri $URI
    }
    catch {
        Write-Warning "retrying..."
        $Result = Invoke-RestMethod -Uri $URI
    }
    return $Result.toplevel.child
}
Clear-Host