function New-DynDnsRecord {
    [CmdLetBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions','Creates instance of DynDns record; does not make changes')]
    param(

        [Parameter(Mandatory=$true,ParameterSetName='ARecord')]
        [ipaddress]$IPv4Address,

        [Parameter(Mandatory=$true,ParameterSetName='TXTRecord')]
        [string]$Text,

        [Parameter(Mandatory=$true,ParameterSetName='CNAMERecord')]
        [string]$CName,

        [Parameter(Mandatory=$true,ParameterSetName='MXRecord')]
        [string]$MailServer,
        [Parameter(Mandatory=$true,ParameterSetName='MXRecord')]
        [string]$Preference,

        [Parameter(Mandatory=$true,ParameterSetName='SRVRecord')]
        [int]$Port,
        [Parameter(Mandatory=$true,ParameterSetName='SRVRecord')]
        [int]$Priority,
        [Parameter(Mandatory=$true,ParameterSetName='SRVRecord')]
        [string]$Target,
        [Parameter(Mandatory=$true,ParameterSetName='SRVRecord')]
        [int]$Weight,

        [Parameter(Mandatory=$true,ParameterSetName='SOARecord')]
        [string]$ResponsiblePerson,

        [int]$TTL = 0
    )

    switch ($PsCmdlet.ParameterSetName) {
        'ARecord' {
            [DynDnsRecord_A]::New(@{
                rdata = @{
                    address = $IPv4Address.IPAddressToString
                }
                ttl = $TTL.ToString()
                record_type = 'A'
            })
        }
        'TXTRecord' {
            [DynDnsRecord_TXT]::New(@{
                rdata = @{
                    txtdata = $Text
                }
                ttl = $TTL.ToString()
                record_type = 'TXT'
            })
        }
        'CNAMERecord' {
            [DynDnsRecord_CNAME]::New(@{
                rdata = @{
                    cname = $Cname
                }
                ttl = $TTL.ToString()
                record_type = 'CNAME'
            })
        }
        'SRVRecord' {
            [DynDnsRecord_SRV]::New(@{
                rdata = @{
                    port = $Port.ToString()
                    priority = $Priority.ToString()
                    target = $Target
                    weight = $Weight.ToString()
                }
                ttl = $TTL.ToString()
                record_type = 'SRV'
            })
        }
        'SOARecord' {
            [DynDnsRecord_SOA]::New(@{
                rdata = @{
                    rname = $ResponsiblePerson.Replace('@','.')
                }
                serial_style = $SerialStyle
                ttl = '3600'
                record_type = 'SOA'
            })
        }
        'MXRecord' {
            [DynDnsRecord_MX]::New(@{
                rdata = @{
                    exchange = $MailServer
                    preference = $Preference.ToString()
                }
                ttl = $TTL.ToString()
                record_type = 'MX'
            })
        }
    }
}