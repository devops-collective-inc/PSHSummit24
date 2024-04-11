# Building DSCv3 Resources
This file contains the commands ran before or durring the demos.  
This was all ran in a standard Win11 Dev VM (via Hyper-V Quick Create )  

## Prerequsite
Winget install GoLang.Go  
Winget install git.git  
Winget install Microsoft.PowerShell  
Winget install Microsoft.VisualStudioCode  

New-item $Profile -force  
Notepad.exe $profile  

Function prompt { "[PSHSummit24]>  "}  
Set-PSReadLineOption -PredictionSource None  

git clone https://github.com/PowerShell/DSC.git  
cd ~\dev\DSC\  
.\build.ps1 in DSC repo (let it fail once as it installs all prerequisites)  
relaunch shell since needs npm in path and run .\build.ps1  
Compress-Archive .\bin\debug\* -DestinationPath "$env:USERPROFILE\Downloads\$(dsc --version)-nightly.zip" -force  
--or--  
Curl.exe -Lo $env:USERPROFILE\downloads\dsc.zip https://github.com/PowerShell/DSC/releases/download/v3.0.0-alpha.5/DSC-3.0.0-alpha.5-x86_64-pc-windows-msvc.zip  
Test-Path C:\Users\User\Downloads\dsc.zip  
& 'C:\Program Files\Windows Defender\MpCmdRun.exe' -signatureupdate  
& 'C:\Program Files\Windows Defender\MpCmdRun.exe' -scan -scantype 3 -file   "$env:USERPROFILE\downloads\dsc.zip"  

git clone https://github.com/PowerShell/DSC-Samples.git  
go install github.com/goreleaser/goreleaser@latest  
cd C:\Users\User\dev\DSC-Samples\tstoy  
.\build.ps1

Set-ItemProperty -Path HKCU:\Environment\ -Name Path -Value "$
((Get-ItemProperty -Path HKCU:\Environment\ ).path);$home\.local\bin" 
Set-ItemProperty -Path HKCU:\Environment\ -Name Path -Value "$
((Get-ItemProperty -Path HKCU:\Environment\ ).path);C:\Users\User\dev\DSC-Samples\tstoy\dist\tstoy_windows_amd64_v1\"   

Install vsCode and installed ms-vscode.powershell, redhat.vscode-yaml, ms-dotnettools.csdevkit, ms-dotnettools.csharp and ms-dotnettools.vscode-dotnet-runtime  

## Demo1
mkdir $home\.local\bin  
Expand-Archive 'C:\Users\User\Downloads\dsc 3.0.0-preview.7-nightly.zip' $home\.local\bin  
--or--  
Expand-Archive "$env:USERPROFILE\downloads\dsc.zip" $home\.local\bin\  
dsc  
dsc completer  
dsc completer --help  
dsc completer powershell  
dsc completer powershell | clip.exe  
notepad $PROFILE  
dsc  
dsc resource  
dsc resource list  
dsc resource schema --help  
dsc resource schema -r Test/Echo  
dsc resource schema -r Test/Echo -f json  
dsc resource schema -r Test/Echo -f pretty-json  
dsc resource schema -r Test/Echo | Out-Default  
dsc resource get -h  
dsc resource get -r Test/Echo -i (@{"output" = "Hello PSHSummit"} | ctj -compress )  
dsc resource get -r Test/Echo -i (@{"output" = "Hello PSHSummit"} | ctj -compress ) -f json  
dsc resource get -r Test/Echo -i (@{"output" = "Hello PSHSummit"} | ctj -compress ) -f pretty-json  

## Demo2
dsc schema  
dsc schema --help  
dsc schema -t resource-manifest  
tzutil.exe  
tzutil.exe /g  
tzutil.exe /l  
dsc resource list  
copy ..\json\tzutil.dsc.resource.json $home\.local\bin\  
dsc resource list  
dsc resource get -r Microsoft/tzutil  
dsc resource set -r Microsoft/tzutil -h  
dsc resource schema -r Microsoft/tzutil   
dsc resource set -r Microsoft/tzutil -i '{"timezone": "UTC"}'  
dsc resource set -r Microsoft/tzutil -i '{"timezone": "PST"}'  
dsc resource set -r Microsoft/tzutil -i '{"timezone": "Pacific Standard time"}'  
dsc resource set -r Microsoft/tzutil -i '{"timezone": "Pacific Standard Time"}'  
dsc resource set -r Microsoft/tzutil -i '{"timezone": "Pacific Standard Time", "dstoff": true}'  
dsc resource set -r Microsoft/tzutil -i '{"timezone": "Pacific Standard Time", "dstoff": false}'  
dsc resource test -r Microsoft/tzutil -i '{"timezone": "Pacific Standard Time", "dstoff": false}'  
clear  

## Demo3
tstoy  
tstoy show  
tstoy show path  
rm C:\Users\User\AppData\Local\TailSpinToys\tstoy\tstoy.config.json  
Test-Path (Tstoy show path user)  
Test-Path (Tstoy show path machine)  
dotnet publish --self-contained -o $home\.local\bin  
csharptstoy.exe   
csharptstoy.exe get  
csharptstoy.exe get --all  
csharptstoy.exe get --scope user  
csharptstoy.exe get --scope machine  
csharptstoy.exe get --inputJSON (@{"scope" = "user"; "ensure" = "absent"} | ctj)  
csharptstoy.exe set --inputJSON (@{"scope" = "user"; "ensure" = "present"; "updateAutomatically" = $true} | ctj)  
Test-Path (Tstoy show path user)  
(@{"scope" = "user"; "ensure" = "absent"; "updateAutomatically" = $true} | ctj) | csharptstoy.exe set  
copy .\csharptstoy.dsc.resource.json $home\.local\bin  
dsc resource list  
dsc resource get -r TSToy.Example/csharptstoy --all  
dsc resource set -r TSToy.Example/csharptstoy  
dsc resource set -r TSToy.Example/csharptstoy -i (@{'ensure'='present'; 'scope'='user'} | ctj)  
tstoy show path  
Test-Path C:\Users\User\AppData\Local\TailSpinToys\tstoy\tstoy.config.json  
dsc resource set -r TSToy.Example/csharptstoy -i (@{'ensure'='present'; 'scope'='machine'} | ctj)  
