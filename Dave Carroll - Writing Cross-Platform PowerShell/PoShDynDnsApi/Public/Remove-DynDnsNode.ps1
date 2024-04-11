function Remove-DynDnsNode {
    [CmdLetBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Node,
        [switch]$Force
    )

    if (-Not (Test-DynDnsSession)) {
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

    if ($Fqdn -notmatch $Zone ) {
        Write-Warning -Message "The zone ($Zone) does not contain $Fqdn."
        return
    }

    if ($null -eq (Get-DynDnsZone -Zone $Zone)) {
        return
    }

    $ZoneRecords = Get-DynDnsRecord -Zone $Zone -Node $Node -RecordType All
    $HttpRedirects = Get-DynDnsHttpRedirect -Zone $Zone -Node $Node

    if ($ZoneRecords -or $HttpRedirects) {
        if (-Not $Force) {
            Write-Warning -Message "The node ($Fqdn) contains records or services. Use the -Force switch if you wish to proceed."
            return
        } else {
            $Message = "`n"
            $Message += "`n" + ('-' * 80) + "`n"
            $Message += 'PROCEEDING WILL DELETE ALL RECORDS AND SERVICES CONTAINED WITHIN THE NODE' + "`n"
            $Message += 'THIS INCLUDES ALL CHILD NODES' + "`n"
            $Message += '-' * 80 + "`n"

            if ($ZoneRecords) {
                $Message += "`n"
                $Header = "Zone records for ${Fqdn}:"
                $Message += "$Header`n"
                $Message += '-' * $Header.Length + "`n"
                $Message += ($ZoneRecords | Out-String).Trim()
                $Message += "`n"
            }
            if ($HttpRedirects) {
                $Message += "`n"
                $Header = "HTTP redirects for ${Fqdn}:"
                $Message += "$Header`n"
                $Message += '-' * $Header.Length + "`n"
                $Message += ($HttpRedirects | Out-String).Trim()
                $Message += "`n"
            }
            $Message += "`n" + ('-' * 80) + "`n"
            $Message += "`n"
            $Message
        }
    }

    if ($PSCmdlet.ShouldProcess("$Fqdn",'Delete node, child nodes, and all records')) {
        $RemoveNode = Invoke-DynDnsRequest -UriPath "/REST/Node/$Zone/$Fqdn" -Method Delete
        Write-DynDnsOutput -DynDnsResponse $RemoveNode
    } else {
        Write-Verbose 'Whatif : Removed node'
    }
}