Expand-Archive "C:\Users\Administrator\Downloads\snmp_exporter-0.25.0.windows-amd64.zip" -DestinationPath 'C:\snmp_exporter'
Move-Item 'C:\snmp_exporter\snmp_exporter-0.25.0.windows-amd64\*' -Destination 'C:\snmp_exporter'
Remove-Item 'C:\snmp_exporter\snmp_exporter-0.25.0.windows-amd64' -recurse -Force

#validate the configuration
Push-Location 'C:\snmp_exporter'
& 'C:\snmp_exporter\snmp_exporter.exe' --config.file="C:\snmp_exporter\snmp.yml"
Pop-Location

#Install as a service
nssm install snmp_exporter
