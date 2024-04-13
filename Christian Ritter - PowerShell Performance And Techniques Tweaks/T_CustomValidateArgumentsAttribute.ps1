<# Valid mail addresses
simple@example.com
very.common@example.com
x@example.com (one-letter local-part)
long.email-address-with-hyphens@and.subdomains.example.com
user.name+tag+sorting@example.com (may be routed to user.name@example.com inbox depending on mail server)
name/surname@example.com (slashes are a printable character, and allowed)
admin@example (local domain name with no TLD, although ICANN highly discourages dotless email addresses[29])
example@s.example (see the List of Internet top-level domains)
" "@example.org (space between the quotes)
"john..doe"@example.org (quoted double dot)
mailhost!username@example.org (bangified host route used for uucp mailers)
"very.(),:;<>[]\".VERY.\"very@\\ \"very\".unusual"@strange.example.com (include non-letters character AND multiple at sign, the first one being double quoted)
user%example.com@example.org (% escaped mail route to user@example.com via example.org)
user-@example.org (local-part ending with non-alphanumeric character from the list of allowed printable characters)
postmaster@[123.123.123.123] (IP addresses are allowed instead of domains when in square brackets, but strongly discouraged)
postmaster@[IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334] (IPv6 uses a different syntax)
_test@[IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334] (begin with underscore different syntax)

Source: https://en.wikipedia.org/wiki/Email_address#:~:text=The%20format%20of%20an%20email,RFC%203696%20(written%20by%20J.
#>


function Send-mail {
    param (
        $MailAddress
    )
    if([string]::IsNullOrEmpty($MailAddress)){
        Throw [System.ArgumentException]::new("The argument is null or empty")
        return
    }
    if($MailAddress -notmatch "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"){
        Throw [System.ArgumentException]::new("Invalid email address format")
        return
    }
    # Rest of Code
    Write-Host "That is a really tasty Mail-Address"
}
Send-mail -MailAddress 'ThrowATErrorDotCom'
Send-mail -MailAddress $null
Send-mail -MailAddress ""
Send-mail -MailAddress "Christian.Ritter@cacnom.de"


function Send-MailBetter {
    param (

        [Parameter(Mandatory)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" ? $true : $(Throw [System.ArgumentException]::new("Invalid email address format"))})]
        [ValidateNotNullOrEmpty()]
        $MailAddress
    )
    # Rest of Code
    Write-Host "That is a really tasty Mail-Address"

        
}
Send-MailBetter -MailAddress $null
Send-MailBetter -MailAddress ""
Send-MailBetter -MailAddress 'ThrowATErrorDotCom'
Send-MailBetter -MailAddress 'mail@test.blah.com'
    
    
    
class ValidateEmailAddressAttribute : System.Management.Automation.ValidateArgumentsAttribute{
    [void] Validate([object]$arguments, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics){
        $email = $arguments
        $emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

        switch ($email) {
            {[string]::IsNullOrEmpty($psitem)} { Throw [System.ArgumentException]::new("The argument is null or empty") }
            {$PSItem -notmatch $emailRegex} { Throw [System.ArgumentException]::new("Invalid email address format")}
        }
    }
}
function Send-MailBest {
    param (
        [ValidateEmailAddressAttribute()]
        $MailAddress
    )
    # Rest of Code
    Write-Host "That is a really tasty Mail-Address"

}

Send-MailBest -MailAddress $null
Send-MailBest -MailAddress ""
Send-MailBest -MailAddress 'ThrowATErrorDotCom'

function Send-MailBetterBest {
    param (
        [Parameter(Mandatory)]
        [net.mail.mailaddress]
        $MailAddress
    )
    # Rest of Code
    Write-Host "That is a really tasty Mail-Address"

}

Send-MailBetterBest -MailAddress $null
Send-MailBetterBest -MailAddress ""
Send-MailBetterBest -MailAddress 'ThrowATErrorDotCom'


#region Secret about betterbest
    #why it might be not better than previous best
    Send-MailBetterBest -MailAddress 'Throw@ErrorDotCom'
#endregion

Get-Content -Path .\address.txt | ForEach-Object{
    Send-MailBetterBest -MailAddress $_
}