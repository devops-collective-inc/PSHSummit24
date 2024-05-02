#DON'T DO THIS AT HOME
$ClientID = "your Client ID"
$TenantID="your Tenant ID"
$clientSecret = "your Secret"
#DON'T DO THIS AT HOME


#Authentication
#Connect to GRAPH API
$token_Body = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}
$token_Response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $token_Body
$token_Header = @{
    "Authorization" = "Bearer $($token_Response.access_token)"
    "Content-type"  = "application/json"
}






#Simple Call

#User Count
(Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/users" -Headers $token_Header).value.count
#Group Count
(Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/groups" -Headers $token_Header).value.count


#User Return
Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/users" -Headers $token_Header
#Group Return
Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/groups" -Headers $token_Header








#####################
#Paging for Beginners
####################
(Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/users" -Headers $token_Header).'@odata.nextLink'

#Next Link
$NextLink=(Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/users" -Headers $token_Header).'@odata.nextLink'

(Invoke-RestMethod -Method GET -Uri $($NextLink) -Headers $token_Header).value.count

#NExt Link2
$NextLink2=(Invoke-RestMethod -Method GET -Uri "$NextLink" -Headers $token_Header).'@odata.nextLink'
(Invoke-RestMethod -Method GET -Uri $($NextLink2) -Headers $token_Header).value.count














#Paging bit better
$Users = @()

$Response = Invoke-RestMethod -Method GET -Uri "https://graph.microsoft.com/v1.0/users" -Headers $token_Header 
$Users = $Response.value

while ($($Response."@odata.nextLink") -ne $null) {

    $Response = (Invoke-RestMethod -Uri $($Response."@odata.nextLink") -Headers $token_Header -Method Get)
    $Users += $Response.value
}

    
return $Users.count









#Function

function Get-AzureResourcePaging {
    param (
        $URL,
        $AuthHeader
    )
 
    $Response = Invoke-RestMethod -Method GET -Uri $URL -Headers $AuthHeader
    $Resources = $Response.value
   
    while ($null -ne $($Response."@odata.nextLink")) {
        $Response = (Invoke-RestMethod -Uri $($Response."@odata.nextLink") -Headers $token_Header -Method Get)
        $Resources += $Response.value
    }

    if ($null -eq $Resources) {
        $Resources = $Response
    }
    return $Resources
}


$FunctionUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users" -AuthHeader $token_Header
$FunctionUsers.count








