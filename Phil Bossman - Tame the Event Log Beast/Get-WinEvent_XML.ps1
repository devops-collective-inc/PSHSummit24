$admCred = Get-Credential -Store -UserName "summit2024\jpetty"
$PSDefaultParameterValues.add("*:Credential", $admCred)

$xmlFilter = @"
<QueryList>
    <Query Id="0" Path="Security">
        <Select Path="Security">*</Select>
        <Suppress Path="Security">
            *[ System[EventID=4688]] and 
            *[ EventData[ Data[@Name='SubjectLogonId'] = '0x3e7' and ( 
                Data[@Name='NewProcessName'] = 'C:\Windows\System32\SearchFilterHost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\SysWOW64\SearchProtocolHost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\SearchProtocolHost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\backgroundTaskHost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\conhost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\wbem\WmiPrvSE.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\taskhost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\taskeng.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\svchost.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\sc.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\rundll32.exe'
                    or Data[@Name='NewProcessName'] = 'C:\Windows\System32\taskhostex.exe'
            )]]
            </Suppress>
        <Suppress Path="Security">
            (*[System[EventID=4769]] and *[EventData[Data[@Name='ServiceName'] = 'krbtgt']])
                or (*[System[EventID=4770]])
                or (*[System[EventID=4624]] and *[EventData[Data[@Name='LogonType'] = '3']])
                or (*[System[EventID=4634]] and *[EventData[Data[@Name='LogonType'] = '3']])
        </Suppress>
    </Query>
</QueryList>
"@

Get-WinEvent -FilterXml $xmlFilter -ComputerName ADM1 -Credential $admCred