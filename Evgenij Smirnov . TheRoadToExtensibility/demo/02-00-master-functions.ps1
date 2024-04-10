<#
    Master Functions
    
    Sample code from 'The road to extensibility'
    2024-04-11 by @cj_berlin @ PSHSummit 2024
#>
#region master function
function Invoke-CompanyInventory {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('Windows','Database')]
        [string]$Target,
        [Parameter(Mandatory=$false)]
        [ValidateSet('WinRM','WMI','SSH','SQL','PostgreSQL','SQLite')]
        [string]$Protocol,
        [Parameter(Mandatory=$false)]
        [string]$Name,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )
    switch ("$($Target)-$($Protocol)") {
        'Windows-WMI' {
            Invoke-WindowsInventoryWMI -ComputerName $Name -Credential $Credential        
         }
         'Windows-SSH' {
            Invoke-WindowsInventorySSH -ComputerName $Name -Credential $Credential        
         }
         'Database-SQL' {
            Get-SQLReport -Database $Name -Credential $Credential        
         }
        default { Write-Warning 'This combo is not going to fly...' }
    }
}
#endregion
#region private functions
function Invoke-WindowsInventoryWMI {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )
    Write-Host 'Doing WMI stuff to Windows'
}
function Invoke-WindowsInventorySSH {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$ComputerName,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )
    Write-Host 'Doing SSH stuff to Windows'
}
function Get-SQLReport {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Database,
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credential
    )
    Write-Host 'Reporting on SQL database'
}

#endregion