#Unpack Prometheus
Expand-Archive C:\Users\Administrator\Downloads\prometheus-2.50.1.windows-amd64.zip -DestinationPath 'C:\prometheus'
Move-Item C:\prometheus\prometheus-2.50.1.windows-amd64\* -Destination 'C:\prometheus'
Remove-Item C:\prometheus\prometheus-2.50.1.windows-amd64 -recurse -Force

#Put my configuration in place here

#Validate configuration
Push-Location C:\prometheus
& .\prometheus.exe --config.file="C:\prometheus\prometheus.yml" --web.config.file="C:\prometheus\web-config.yml"
Pop-Location

#Make sure I didn't screw up
start-process https://prometheus.steviecoaster.dev:9090


#Setup the service
nssm install prometheus

#Make sure I didn't screw up, again because I don't trust myself
start-process https://prometheus.steviecoaster.dev:9090
