function Lock-DynDnsZone {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $JsonBody = @{
        freeze = $true
    } | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess($Zone,"Freeze zone")) {
        $LockZone = Invoke-DynDnsRequest -UriPath "/REST/Zone/$Zone" -Method Put -Body $JsonBody
        Write-DynDnsOutput -DynDnsResponse $LockZone
    } else {
        Write-Verbose 'Whatif : Zone frozen'
    }
}