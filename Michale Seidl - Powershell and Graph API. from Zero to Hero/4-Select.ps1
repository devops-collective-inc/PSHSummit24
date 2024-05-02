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

#region function
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

#endregion function


##CUSTOM CODE, ALL ABOVE STAYS THE SAME



$AllUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users" -AuthHeader $token_Header
$AllUsers[0]
#Properties: https://learn.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0#properties



#Single Property
$AllUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users?`$select=displayname" -AuthHeader $token_Header
$AllUsers[0]



#Additonal Property, City
$AllUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users?`$select=displayname,city" -AuthHeader $token_Header
$AllUsers[0..10]

