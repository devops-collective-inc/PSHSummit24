#---- Tip 1 - Don’t neglect PowerShell 5.1

# Different IRM options
$Result = Invoke-RestMethod -Uri http://localhost -AllowInsecureRedirect

# No count when arrays are enumerated to a single item
$Result = @"
{ 
    "name": "stuart",
    "hobby": "powershell"
}
"@ | ConvertFrom-Json
if ($Result.count -eq 1) {
    $Result.name
}