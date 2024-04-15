function Add-DynDnsHttpRedirect {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,

        [string]$Node,

        [Parameter(Mandatory=$true)]
        [string]$Url,

        [ValidateSet('301','302')]
        [string]$ResponseCode = '301',

        [switch]$IncludeUri
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($Url -notmatch '^http://|^https://') {
        Write-Warning -Message "The URL provided does not begin with 'http://' or 'https://'."
        return
    }

    if ($Node) {
        if ($Node -match $Zone ) {
            $Fqdn = $Node
        } else {
            $Fqdn = $Node + '.' + $Zone
        }
    } else {
        $Fqdn = $Zone
    }

    if ($IncludeUri) {
        $KeepUri = 'Y'
    } else {
        $KeepUri = 'N'
    }

    $JsonBody = @{
        code = $ResponseCode
        keep_uri = $KeepUri
        url = $Url
    } | ConvertTo-Json

    Write-Warning -Message 'This will autopublish the HTTP redirect to the zone.'

    if ($PSCmdlet.ShouldProcess("$Fqdn","Create HTTP redirect to $Url")) {
        $NewHttpRedirect = Invoke-DynDnsRequest -UriPath "/REST/HTTPRedirect/$Zone/$Fqdn" -Method Post -Body $JsonBody
        Write-DynDnsOutput -DynDnsResponse $NewHttpRedirect
    } else {
        Write-Verbose 'Whatif : Created new HTTP redirect'
    }
}