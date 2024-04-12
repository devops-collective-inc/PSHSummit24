# Key Vault Demo
# NOTE: This "script" is NOT intended for execution in whole, but is rather for demo purposes

### Defined Variables ###

# Vault Creation Variables
$VaultName = "ANDOKVPWSHSUMMIT"
$ResourceGroup = "Test-Dev"
$AzureRegion = "northcentralus"

# Username variable used later in the script during VM info retrieval
$Username = "Administrator"

# The below are used if you want to configure additional user access to the vault
$NewUserVaultPermissions = "get,set,delete"
$NewUserUPN = "gandalf@middle.earth"

### Function Establishment ###

# Function for the creation of random strings
function Generate-RandomPassword {
    param (
        [int]$length = 12
    )

    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()"
    $password = -join ((1..$length) | ForEach-Object { Get-Random -Maximum $chars.Length } | ForEach-Object { $chars[$_ - 1] })

    return $password
}

### Building an Azure Key Vault with PowerShell ###

# OPTIONAL: In the event you don't have a resource group created already you can use the below
New-AzResourceGroup -Name $ResourceGroup -Location $AzureRegion

# Let's actually create a new key vault
New-AzKeyVault -Name $VaultName -ResourceGroupName $ResourceGroup -Location $AzureRegion

# We can list all known vaults using the below
Get-AzKeyVault

# By default the account that created the new vault is the one that has access to it.
# OPTIONAL: If you need to configure access for additional users - use the below:
Set-AzKeyVaultAccessPolicy -VaultName $VaultName -UserPrincipalName $NewUserUPN -PermissionsToSecrets $NewUserVaultPermissions

### Adding Secrets to the Vault ###

# Let's place a new secret in the vault by first converting text to a secure string
$Secretvalue = ConvertTo-SecureString "Password01!" -AsPlainText -Force

# We then use the below to inject the secret into the vault
Set-AzKeyVaultSecret -VaultName $VaultName -Name "SuperSecretPassword" -SecretValue $Secretvalue

# If needed you can query the vault for a list of known secrets
Get-AzKeyVaultSecret -VaultName $VaultName

# If we need to retrieve the credentials later on - run the below
$RetreivedSecret = Get-AzKeyVaultSecret -VaultName $VaultName -Name "SuperSecretPassword" -AsPlainText

# Return the value of the secret
Write-Host $RetreivedSecret

### Retreived Key Vault Credentials - Practical Use ###

# We first must Build the Credentials to be used by PowerShell
$Secretvalue = ConvertTo-SecureString $RetreivedSecret -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $Secretvalue)

# Script Execution - Retreive information from a VM with PowerShell Direct (-VMName Parameter) using the creds stored in Key Vault
$TargetMachineHostname = Invoke-Command -VMName "WinServ2022" -Credential $Credential -ScriptBlock {hostname}
Write-Host "Hostname of Target System is: $TargetMachineHostname" 
$ProcessList = Invoke-Command -VMName "WinServ2022" -Credential $Credential -ScriptBlock {Get-Process | Select-Object -First 5}
Write-Host "First Five Listed Processes Are: $ProcessList"

### Optional (BUT RECOMENDED IN SECURE ENVIRONMENTS): the below module can help output key vault secrets
### as Secure Strings.
Install-Module Microsoft.PowerShell.SecretManagement -Repository PSGallery -AllowPrerelease

### What if we need a passphrase generated for us? ###

# Create a Random Password
$randomPassword = Generate-RandomPassword -length 22

# Optional: Return the results if you're curious
Write-Host $randomPassword

# Let's place a new secret in the vault by first converting text to a secure string
$Secretvalue = ConvertTo-SecureString $randomPassword -AsPlainText -Force

# We then use the below to inject the secret into the vault
Set-AzKeyVaultSecret -VaultName $VaultName -Name "SuperSecret-RANDOM-Password" -SecretValue $Secretvalue

# Again we can return a list of known secrets
Get-AzKeyVaultSecret -VaultName $VaultName

# If we need to retrieve the credentials later on - run the below
$RetreivedSecret = Get-AzKeyVaultSecret -VaultName $VaultName -Name "SuperSecret-Random-Password" -AsPlainText

# Return the value of the secret
Write-Host $RetreivedSecret

# Vault Cleanup at End of Demo - NOTE: Deletion can be prevented with soft-delete and purge protection
Remove-AzKeyVault -Name $VaultName

# Optional: If you want to list "soft deleted" vaults, use the below.
Get-AzKeyVault -InRemovedState

# Optional: Recover Soft-Deleted Vault
Undo-AzKeyVaultKeyRemoval -VaultName $VaultName -Location $AzureRegion

# Optional: To REALLY REALLY REALLY delete your vault use the below
Remove-AzKeyVault -Name $VaultName -InRemovedState -Location $AzureRegion

# To prevent vault purging you can use the below to turn on purge protection
# Note: Not even Admins can disable purge protection once enabled!
Update-AzKeyVault -VaultName $VaultName -ResourceGroupName $ResourceGroup -EnablePurgeProtection

### Cmdlets for AZ Key Vault Firewall ###
Add-AzKeyVaultNetworkRule
New-AzKeyVaultNetworkRuleSetObject
Remove-AzKeyVaultNetworkRule
Update-AzKeyVaultNetworkRuleSet
