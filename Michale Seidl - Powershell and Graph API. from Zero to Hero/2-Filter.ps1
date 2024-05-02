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

####
#Find User with FirstName = James


#Method 1
# Get ll Users and Where-Object

$AllUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users" -AuthHeader $token_Header
$AllJamesUsers=$AllUsers | Where-Object {$_.givenName -eq "James"} 
$AllJamesUsers.count















#Method 2
#get all James user with a foreach
$AllUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users" -AuthHeader $token_Header

$JamesUsers=@()

foreach ($User in $AllUsers){
    if ($User.givenName -eq "James"){
        $JamesUsers+=$User
    }
}
$JamesUsers.count

















#Method 3, the best Options
$JamesUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users?`$filter=givenName eq 'James'" -AuthHeader $token_Header
$JamesUsers.count







#Other Examples
#https://learn.microsoft.com/en-us/graph/filter-query-parameter?tabs=http


$JamesUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users?`$filter=startsWith(givenName, 'James')" -AuthHeader $token_Header
$JamesUsers.count









#Advanced
# https://learn.microsoft.com/en-us/graph/filter-query-parameter?tabs=http#**

$token_Header = @{
    "Authorization" = "Bearer $($token_Response.access_token)"
    "Content-type"  = "application/json"
    "ConsistencyLevel" = "eventual"
}

$JamesUsers=Get-AzureResourcePaging -URL "https://graph.microsoft.com/v1.0/users?`$filter=givenName ne 'James'&`$count=true" -AuthHeader $token_Header
$JamesUsers.count




#Think about using foreach or where object now ?????










#Group Membership

# Get Members of a Group wehere Job Titel is DEVOPS DEMO
#https://devblogs.microsoft.com/microsoft365dev/build-advanced-queries-with-count-filter-search-and-orderby/
$GroupName="PowerShellDevOps Global Summit"
$GetGroupURL = "https://graph.microsoft.com/v1.0/groups?`$filter=displayname eq '$GroupName'"
$Group=Invoke-RestMethod -Method Get -Uri $GetGroupURL -Headers $token_Header










#Way before Filtering
# Get all Members and than filter Resutl

$GetMemberURL = "https://graph.microsoft.com/v1.0/groups/$($Group.value.id)/members"
$Out=Invoke-RestMethod -Method Get -Uri $GetMemberURL -Headers $token_Header

$Out.value
$out.value.count


$Out.value | Where-Object {$_.jobTitle -eq "DEVOPS DEMO"}
($Out.value | Where-Object {$_.jobTitle -eq "DEVOPS DEMO"}).count












#Way to go

$token_Header = @{
    "Authorization" = "Bearer $($token_Response.access_token)"
    "Content-type"  = "application/json"
    "ConsistencyLevel" = "eventual"
}

$GetMemberURL = "https://graph.microsoft.com/v1.0/groups/$($Group.value.id)/members/microsoft.graph.user?`$count=true&`$filter=jobTitle eq 'DEVOPS DEMO'"  
$Out=Invoke-RestMethod -Method Get -Uri $GetMemberURL -Headers $token_Header


$Out.value.count



