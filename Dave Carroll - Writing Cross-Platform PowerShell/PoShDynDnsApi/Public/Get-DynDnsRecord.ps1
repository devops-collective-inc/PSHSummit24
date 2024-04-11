function Get-DynDnsRecord {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Zone,
        [ValidateSet('SOA','NS','MX','TXT','SRV','CNAME','PTR','A','All',IgnoreCase=$false)]
        [string]$RecordType = 'All',
        [string]$Node
    )

    if (-Not (Test-DynDnsSession)) {
        return
    }

    if ($Node) {
        if ($Node -match $Zone ) {
            $UriPath = '/REST/{0}Record/{1}/{1}' -f $RecordType,$Zone
        } else {
            $UriPath = '/REST/{0}Record/{1}/{2}.{1}' -f $RecordType,$Zone,$Node
        }
    } else {
        'No node provided. {0} record types for zone tree will be returned.' -f $RecordType | Write-Verbose
        $UriPath = '/REST/AllRecord/{0}' -f $Zone
    }

    $Records = Invoke-DynDnsRequest -UriPath $UriPath
    Write-DynDnsOutput -DynDnsResponse $Records -SkipSuccess
    if ($Records.Data.status -eq 'failure') {
        return
    }

    if ($RecordType -eq 'All') {
        $RecordTypeFilter = '\S+' # match on all
    } else {
        $RecordTypeFilter = '/{0}Record' -f $RecordType # match only on requested record type
    }

    foreach ($UriPath in $Records.Data.data) {
        if ($UriPath -match $RecordTypeFilter) {
            $RecordData = Invoke-DynDnsRequest -UriPath $UriPath
            Write-DynDnsOutput -DynDnsResponse $RecordData
        } else {
            'Skipping {0} due to RecordType' -f $UriPath | Write-Verbose
        }
    }
}