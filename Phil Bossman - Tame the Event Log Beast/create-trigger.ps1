# Created for: https://github.com/phbits/WebsiteFailedLogins/issues/2

## Source: https://gist.githubusercontent.com/phbits/6c927dcc478af6e91248c9d075096c0a/raw/7a3652553767d4b6e0d92da7b026432d96941008/Create-EventTrigger.ps1


# NOTE - ExecutionPolicy set to Unrestricted should only be used for testing.
$Action = New-ScheduledTaskAction -Execute 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe' `
  -Argument '-NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -File .\Alert_DA.ps1 -EventRecordID $(EventRecordID) -ComputerName $(ComputerName) -User $(User) -SourceAddress $(SourceAddress) -ExecutionPolicy Unrestricted' `
  -WorkingDirectory 'C:\Github\'

$Principal = New-ScheduledTaskPrincipal -UserId 'NT AUTHORITY\SYSTEM' -LogonType ServiceAccount

$Settings = New-ScheduledTaskSettingsSet -DisallowDemandStart -Compatibility Win8 -Hidden -WakeToRun -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries

$Settings.RunOnlyIfIdle = $FALSE
$Settings.ExecutionTimeLimit = 'PT5M'
$Settings.StartWhenAvailable = $TRUE
$Settings.StopIfGoingOnBatteries = $FALSE
$Settings.DisallowStartOnRemoteAppSession = $FALSE
$Settings.DisallowStartIfOnBatteries = $FALSE

# Create Trigger via Security Event ID 1102
$cimTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger `
  -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger

$Trigger = New-CimInstance -CimClass $cimTriggerClass -ClientOnly

$qry = @"
<QueryList>
  <Query Id="0" Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational">
    <Select Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational">
        *[System[(EventID=22)]]
    </Select>
  </Query>
</QueryList>
"@
$Trigger.Subscription = $qry

$Trigger.ExecutionTimeLimit = 'PT5M'
$Trigger.Enabled = $TRUE

$eventData = @{
  EventRecordID = 'Event/System/EventRecordID'
  ComputerName  = 'Event/System/Computer'
  User          = 'Event/UserData/EventXML/User'
  SourceAddress = 'Event/UserData/EventXML/Address'
}
$data = $eventData.keys | ForEach-Object {
  [CimInstance]$cim = $(Get-CimClass -ClassName MSFT_TaskNamedValue -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskNamedValue)
  $cim.Name = $_
  $cim.value = $eventData["$_"]
  $cim
}
$Trigger.ValueQueries = $data

Register-ScheduledTask -TaskName 'Alert_DA' `
  -Description 'Run script on DA Login' `
  -TaskPath '\' `
  -Action $Action `
  -Trigger $Trigger `
  -Settings $Settings `
  -Principal $Principal 
                