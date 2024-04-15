function Add-DynDnsZone {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='Zone')]
        [Parameter(Mandatory=$true,ParameterSetName='ZoneFile')]
        [string]$Zone,

        [Parameter(Mandatory=$true,ParameterSetName='Zone')]
        [string]$ResponsiblePerson,

        [Parameter(ParameterSetName='Zone')]
        [ValidateSet('increment','epoch','day','minute')]
        [string]$SerialStyle = 'day',

        [Parameter(ParameterSetName='Zone')]
        [int]$TTL = 3600,

        [Parameter(ParameterSetName='ZoneFile')]
        [ValidateScript({Test-Path $_})]
        [string]$ZoneFile
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    $EmailRegex = '^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'

    switch ($PsCmdlet.ParameterSetName) {
        'Zone' {
            if ($ResponsiblePerson -notmatch $EmailRegex) {
                Write-Warning -Message 'The value provided for ResponsiblePerson does not appear to be a valid email. Please try again.'
                return
            }
            $UriPath = "/REST/Zone/$Zone"
            $JsonBody = @{
                rname = $ResponsiblePerson.Replace('@','.')
                serial_style = $SerialStyle
                ttl = $TTL.ToString()
            } | ConvertTo-Json
        }
        'ZoneFile' {
            $UriPath = "/REST/ZoneFile/$Zone"
            $JsonBody = @{
                file = "$(Get-Content -Path $ZoneFile -Raw)"
            } | ConvertTo-Json
        }
    }

    if ($PSCmdlet.ShouldProcess("$Zone","Create DNS zone by $($PsCmdlet.ParameterSetName) method")) {
        $NewZone = Invoke-DynDnsRequest -UriPath $UriPath -Method Post -Body $JsonBody
        ''
        Write-DynDnsOutput -DynDnsResponse $NewZone
        if ($NewZone.Data.Status -eq 'success') {
            'Note: Be sure to use the function Publish-DynDnsZoneChanges with the -Force switch in order publish the domain.'
        }
    } else {
        Write-Verbose 'Whatif : Created new zone'
    }
}