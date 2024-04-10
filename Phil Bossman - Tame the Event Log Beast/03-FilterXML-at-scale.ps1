Get-WinEvent -FilterXml $filterXML -ComputerName { Get-ADComputer -Filter * }

$servers | ForEach-Object {
  Get-WinEvent -FilterXml $filterXML -ComputerName $_
}


