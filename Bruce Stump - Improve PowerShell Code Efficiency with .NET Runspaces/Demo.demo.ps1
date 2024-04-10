# 1. Namespace

# .Silent cls

# List namespaces on computer.

[System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | Select NameSpace -Unique | Select -First 20

# [Namespace.Typename]
[System.Text.Decoder]

# Display namespace

[System.AppDomain].Namespace

# Display Typename

[System.AppDomain].GetTypeinfo()

# Research Namespaces

Start-Process "https://learn.microsoft.com/en-us/dotnet/api/?view=netframework-4.8&preserve-view=true"

# End Namespace

# 2. Type

# .Silent cls

# Typename of Cmdlet

Get-process | Get-Member | Select -First 20

# Method of Typename

[System.Diagnostics.Process]

[System.Diagnostics.Process] | Get-Member | Select-Object -First 20

[System.Diagnostics.Process] | Get-Member -Static

Get-Process | Select-Object -First 20

[System.Diagnostics.Process]::GetProcesses() | Select-Object -First 20

# End Type

# 3. Class

# .Silent cls

# Classes of Namespace

[AppDomain]::CurrentDomain.GetAssemblies().GetTypes()  | Where-Object {$_.NameSpace -eq 'System.IO'}

Start-Process "https://learn.microsoft.com/en-us/dotnet/api/?view=netframework-4.8&preserve-view=true"

# End Class

# 4. Assembly

# .Silent cls

# List Assemblies
[System.AppDomain]::CurrentDomain.GetAssemblies()

# Class Explorer
Install-Module ClassExplorer
Import-Module ClassExplore
Get-Assembly

# PowerShell Assembly

[System.Management.Automation.PowerShell].Assembly.Location

# End Assembly

# 5.  Runspace

# PowerShell Runspace

Get-Runspace

# PowerShell .NET Structure

[System.Management.Automation.PowerShell]

[PowerShell]

[System.Management.Automation.PowerShell].Namespace

[System.Management.Automation.PowerShell].GetTypeInfo()

[PowerShell] | Get-Member -Static

# Create Example Runspace

[PowerShell]::Create().AddCommand('Get-Process').AddParameter('Name','pwsh').Invoke()


