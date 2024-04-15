# This script assumes you have an Azure Arc Enabled machine with a configured System Account Managed Identity associated with it

$apiVersion = "2020-06-01"
$resource = "https://vault.azure.net"
$endpoint = "{0}?resource={1}&api-version={2}" -f $env:IDENTITY_ENDPOINT,$resource,$apiVersion
$secretFile = ""
try
{
    Invoke-WebRequest -Method GET -Uri $endpoint -Headers @{Metadata='True'} -UseBasicParsing
}
catch
{
    $wwwAuthHeader = $_.Exception.Response.Headers["WWW-Authenticate"]
    if ($wwwAuthHeader -match "Basic realm=.+")
    {
        $secretFile = ($wwwAuthHeader -split "Basic realm=")[1]
    }
}
Write-Host "Secret file path: " $secretFile`n
$secret = cat -Raw $secretFile
$response = Invoke-WebRequest -Method GET -Uri $endpoint -Headers @{Metadata='True'; Authorization="Basic $secret"} -UseBasicParsing
if ($response)
{
    $token = (ConvertFrom-Json -InputObject $response.Content).access_token
    Write-Host "Access token: " $token
}

# Everything above this line simply grabs a token from Entra assuming the machine running this script is configured with a system account managed identity

# The below one liner simply uses that token to retrieve a key from keyvault without have to provide a username / password combo to access key vault
# NOTE: Make sure you change the Vault URI and Secret name in the command below!!!!
Invoke-RestMethod -Uri https://<Vault URI HERE>/secrets/<Secret Name Here>?api-version=2016-10-01 -Method GET -Headers @{Authorization="Bearer $token"}