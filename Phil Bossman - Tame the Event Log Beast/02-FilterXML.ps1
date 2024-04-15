$filterXML = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*</Select>
  </Query>
</QueryList>
"@
Get-WinEvent -FilterXml $filterXML

