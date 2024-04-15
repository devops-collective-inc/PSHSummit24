function Get-LineEnding {
    param (
        [string]$Path
    )
    $Content = Get-Content -Path $Path -Raw
    if ($Content -match "`r`n") {
        "CRLF (Windows)"
    } elseif ($Content -match "`n") {
        "LF (Unix/Linux)"
    } elseif ($Content -match "`r") {
        "CR (Old Mac)"
    } else {
        "Unknown line endings"
    }
}

function Get-FileEncoding {
    param (
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_})]
        [string]$Path
    )
    try {
        $ResolvedPath = Resolve-Path -Path $Path
        $Reader = [System.IO.File]::OpenRead($ResolvedPath)
        $Bytes = New-Object byte[] 4
        $Reader.Read($Bytes, 0, 4) | Out-Null
        $Reader.Dispose()
    }
    catch {
        Write-Error -Message "Failed to read file. Error: $_"
    }

    if ($Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
        "UTF16 LE"
    } elseif ($Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
        "UTF16 BE"
    } elseif ($Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) {
        "UTF8 with BOM"
    } else {
        "Unknown/ASCII/UTF8 without BOM"
    }
}

function Get-Uname {
    [CmdLetBinding(
        DefaultParameterSetName='KernelName'
    )]
    param(
        [Parameter(ParameterSetName='All')]
        [Alias('a')]
        [switch]$All,
        [Parameter(ParameterSetName='KernelName')]
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('s')]
        [switch]$KernelName,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('n')]
        [switch]$NodeName,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('r')]
        [switch]$KernelRelease,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('v')]
        [switch]$KernelVersion,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('m')]
        [switch]$Machine,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('p')]
        [switch]$Processor,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('i')]
        [switch]$HardwarePlatform,
        [Parameter(ParameterSetName='ListArgs')]
        [Alias('o')]
        [switch]$OperatingSystem,
        [Parameter(ParameterSetName='Help')]
        [switch]$Help,
        [Parameter(ParameterSetName='Version')]
        [switch]$Version
    )

    begin {
        if ($PSEdition -eq 'Desktop') {
            'This function does not work on Windows Powershell' | Write-Error -ErrorAction Stop
        }
        try {
            $UnameCmd = Get-Command -Name uname -ErrorAction Stop
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $UnameOutput = [ordered]@{
            PSTypeName = 'Linux.uname'
        }

        $AllOptions = @('KernelName','NodeName','KernelRelease','KernelVersion','Machine','Processor','HardwarePlatform','OperatingSystem')

        function GetUnameOption {
            param($Option)
            switch ($Option) {
                'KernelName' { 's'}
                'NodeName' { 'n'}
                'KernelRelease' { 'r'}
                'KernelVersion' { 'v'}
                'Machine' { 'm'}
                'Processor' { 'p'}
                'HardwarePlatform' { 'i'}
                'OperatingSystem' { 'o'}
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'All' {
                foreach ($Key in $AllOptions) {
                    if ($IsMacOS -and $Key -match 'HardwarePlatform|OperatingSystem') {
                        continue
                    }
                    $Option = GetUnameOption -Option $Key
                    $UnameOutput.Add($Key, (Invoke-Expression -Command ('{0} -{1}' -f $UnameCmd.Path,$Option)))
                }
            }
            'KernelName' {
                $Option = GetUnameOption -Option 'KernelName'
                $UnameOutput.Add('KernelName', (Invoke-Expression -Command ('{0} -{1}' -f $UnameCmd.Path,$Option)))
            }
            'Help' {
                Get-Help -Name Get-Uname -Detailed
                return
            }
            'Version' {
                Invoke-Expression -Command ('{0} --version' -f $UnameCmd.Path)
                return
            }
            'ListArgs' {
                foreach ($Key in $PSBoundParameters.Keys) {
                    if ($AllOptions.Contains($Key)) {
                        if ($IsMacOS -and $Key -match 'HardwarePlatform|OperatingSystem') {
                            continue
                        }
                        $Option = GetUnameOption -Option $Key
                        $UnameOutput.Add($Key, (Invoke-Expression -Command ('{0} -{1}' -f $UnameCmd.Path,$Option)))
                    }
                }
            }
        }
        [PsCustomObject]$UnameOutput

    }

    end {

    }

<#
.SYNOPSIS
    Display certain system information
.DESCRIPTION
    Display certain system information using host command uname.

    The alias for the switches match that of the uname command.
.PARAMETER All
    Return all information in the following order:
    KernelName, NodeName, KernelRelease, KernelVersion, Machine,
    Processor, HardwarePlatform, OperatingSystem

    Each will be a property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -a'.

    Note: On MacOS, HardwarePlatform and OperatingSystem will be omitted.
.PARAMETER KernelName
    Return KernelName property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -s'.

    This is the default behavior without using any switch.
.PARAMETER NodeName
    Return NodeName property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -n'.
.PARAMETER KernelRelease
    Return KernelRelease property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -r'.
.PARAMETER KernelVersion
    Return KernelVersion property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -v'.
.PARAMETER Machine
    Return Machine property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -m'.
.PARAMETER Processor
    Return Processor property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -p'.
.PARAMETER HardwarePlatform
    Return HardwarePlatform property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -i'.

    Note: On MacOS, HardwarePlatform will be omitted.
.PARAMETER OperatingSystem
    Return OperatingSystem property of PSCustomObject Linux.uname

    The value of the property will be the same as output from the command: 'uname -o'.

    Note: On MacOS, OperatingSystem will be omitted.
.EXAMPLE
    PS /home/thedavecarroll> Get-Uname

    KernelName
    ----------
    Linux
.EXAMPLE
    PS /home/thedavecarroll> Get-Uname -a

    KernelName       : Linux
    NodeName         : TEMPLES
    KernelRelease    : 4.4.0-18362-Microsoft
    KernelVersion    : #1-Microsoft Mon Mar 18 12:02:00 PST 2019
    Machine          : x86_64
    Processor        : x86_64
    HardwarePlatform : x86_64
    OperatingSystem  : GNU/Linux
.EXAMPLE
    PS /users/thedavecarroll> Get-Uname -a

    KernelName    : Darwin
    NodeName      : Daves-iMac.local
    KernelRelease : 17.7.0
    KernelVersion : Darwin Kernel Version 17.7.0: Thu Dec 20 21:47:19 PST 2018;
                    root:xnu-4570.71.22~1/RELEASE_X86_64
    Machine       : x86_64
    Processor     : i386
.EXAMPLE
    PS /home/thedavecarroll> Get-Uname -Version

    uname (GNU coreutils) 8.28
    Copyright (C) 2017 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.

    Written by David MacKenzie.
.EXAMPLE
    PS /home/thedavecarroll> Get-Uname -Help

    Returns output for Get-Help -Name Get-Uname -Detailed
.INPUTS
    None
.OUTPUTS
    Linux.uname
.LINK
    https://gist.github.com/thedavecarroll/fd01baea04a63f734431a85865602389
.LINK
    https://ironscripter.us/a-powershell-cross-platform-challenge/
#>
}

if (-Not $IsWindows) {
    Set-Alias -Name 'Get-ComputerInfo' -Value 'Get-Uname'
}
# This is a horrible example of how to provide a cross-platform function that
# provides similar information to the Windows Get-ComputerInfo cmdlet.
