#region Unwielding long command with many paramters
New-ADUser -Name "John Doe" -GivenName "John" -Surname "Doe" -SamAccountName "johndoe" -UserPrincipalName "johndoe" -EmailAddress "johndoe@company.com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true -PassThru -Description "New user account" -Title "Mr." -Department "IT" -Company "Company Inc." -Manager "Jane Smith" -HomeDirectory "\\server\share\johndoe" -HomeDrive "H:" -ScriptPath "logon.bat" -ProfilePath "\\server\profiles\johndoe" -LogonScript "logon.bat" -OfficePhone "123-456-7890" -MobilePhone "987-654-3210" -Pager "555-1234" -Fax "555-4321" -StreetAddress "123 Main St" -City "New York" -State "NY" -PostalCode "12345" -Country "USA" -POBox "54321" -OtherAttributes @{'extensionAttribute1'='Value1'; 'extensionAttribute2'='Value2'}
#endregion

#region Backticking to break up the command
New-ADUser `
-Name "John Doe" `
-GivenName "John" `
-Surname "Doe" `
-SamAccountName "johndoe" `
-UserPrincipalName "johndoe" `
-EmailAddress "johndoe@company.com" `
-AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
-Enabled $true `
-PassThru `
-Description "New user account" `
-Title "Mr." `
-Department "IT" `
-Company "Company Inc." `
-Manager "Jane Smith" `
-HomeDirectory "\\server\share\johndoe" `
-HomeDrive "H:" `
-ScriptPath "logon.bat" `
-ProfilePath "\\server\profiles\johndoe" `
-LogonScript "logon.bat" `
-OfficePhone "123-456-7890" `
-MobilePhone "987-654-3210" `
-Pager "555-1234" `
-Fax "555-4321" `
-StreetAddress "123 Main St" `
-City "New York" `
-State "NY" `
-PostalCode "12345" `
-Country "USA" `
-POBox "54321" `
-OtherAttributes @{'extensionAttribute1'='Value1'; 'extensionAttribute2'='Value2'}
#endregion

#region Splatting to break up the command
$newADUserSplat = @{
    Name = "John Doe"
    GivenName = "John"       
    Surname = "Doe"
    SamAccountName = "johndoe"
    UserPrincipalName = "johndoe"
    EmailAddress = "johndoe@company.com"
    AccountPassword = (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
    Enabled = $true
    PassThru = -PassThru
    Description = "New user account"
    Title = "Mr."
    Department = "IT"
    Company = "Company Inc."
    Manager = "Jane Smith"
    HomeDirectory = "\\server\share\johndoe"
    HomeDrive = "H:"
    ScriptPath = "logon.bat"
    ProfilePath = "\\server\profiles\johndoe"
    LogonScript = "logon.bat"
    OfficePhone = "123-456-7890"
    MobilePhone = "987-654-3210"
    Pager = "555-1234"
    Fax = "555-4321"
    StreetAddress = "123 Main St"
    City = "New York"
    State = "NY"
    PostalCode = "12345"
    Country = "USA"
    POBox = "54321"
    OtherAttributes = @{'extensionAttribute1'='Value1'; 'extensionAttribute2'='Value2'}
}

New-ADUser @newADUserSplat

#endregion

#region Combined splatting with parameters
$newADUserSplat = @{
    Name = "John Doe"
    GivenName = "John"
    Surname = "Doe"
    SamAccountName = "johndoe"
    UserPrincipalName = "johndoe"
    EmailAddress = "johndoe@company.com"
}

New-ADUser @newADUserSplat -AccountPassword  (ConvertTo-SecureString $(Get-SuperHighCrypticPassword -Strength 'Unbreakable') -AsPlainText -Force)
#endregion

#region Combined Splatting with another splat
$getChilditemSplat = @{
    Filter = "*.txt"
    Depth = 2
}
function Get-ChilditemWrapper {
    param (
        $Path,
        [switch] $Recurse,
        [switch] $File
    )


    Get-Childitem @getChilditemSplat @PSBoundParameters
}

#endregion