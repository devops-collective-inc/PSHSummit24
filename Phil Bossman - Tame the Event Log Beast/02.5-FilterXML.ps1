$LogName = "Security"
$EventID = "4740"
$filterXML = @"
<QueryList>
  <Query Id="0" Path="$LogName">
    <Select Path="$LogName">*[
        System[
          Provider[@Name='Microsoft-Windows-Security-Auditing'] 
          and (Level=4 or Level=0) and EventID=$EventID]]
    </Select>
  </Query>
</QueryList>
"@
Get-WinEvent -FilterXml $filterXML

