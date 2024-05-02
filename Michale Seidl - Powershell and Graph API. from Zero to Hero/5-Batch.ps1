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



#Create a User
$NewUserBody=@"
{
    "mailNickname":  "Adam.Wagner",
    "surname":  "Wagner",
    "userPrincipalName":  "Adam.Wagner@au2mator.com",
    "displayName":  "Adam.Wagner",
    "givenName":  "Adam",
    "passwordProfile":  {
                            "password":  "P@ssw0rd",
                            "forceChangePasswordNextSignIn":  true
                        },
    "accountEnabled":  false,
    "jobTitle":  "DEVOPS DEMO"
}
"@


$Out=Invoke-RestMethod -Body $NewUserBody -Headers $token_Header -Method Post -Uri "https://graph.microsoft.com/v1.0/users"



#Create a Group
$NewGroupBody=@"
{
    "description": "PS DevOps Group",
    "displayName": "DEVOPSDEMO",
    "groupTypes": [
        "Unified"
    ],
    "mailEnabled": false,
    "mailNickname": "DEVOPSDEMO",
    "securityEnabled": false
}
"@
$Out=Invoke-RestMethod -Body $NewGroupBody -Headers $token_Header -Method Post -Uri "https://graph.microsoft.com/v1.0/groups"





#Get the New User
$Out = Invoke-RestMethod  -Headers $token_Header -Method GET -Uri "https://graph.microsoft.com/v1.0/users?`$filter=userPrincipalName eq 'Adam.Wagner@au2mator.com'"


#Get the New Group

$Out = Invoke-RestMethod  -Headers $token_Header -Method GET -Uri "https://graph.microsoft.com/v1.0/groups?`$filter=displayName eq 'DEVOPSDEMO'"



#


$JsonBody1 = @"
{
    "requests":  [
                     {
                         "id":  "1",
                         "method":  "POST",
                         "url":  "/users",
                         "headers":  {
                                         "Content-Type":  "application/json"
                                     },
                         "body":  {
                                "mailNickname":  "Bert.Wagner",
                                "surname":  "Wagner",
                                "userPrincipalName":  "Bert.Wagner@au2mator.com",
                                "displayName":  "Bert.Wagner",
                                "givenName":  "Bert",
                                "passwordProfile":  {
                                                    "password":  "P@ssw0rd",
                                                    "forceChangePasswordNextSignIn":  true
                                                },
                                "accountEnabled":  false,
                                "jobTitle":  "DEVOPS DEMO"
                                  }
                     },
                     {
                         "id":  "2",
                         "method":  "POST",
                         "url":  "/groups",
                         "headers":  {
                                         "Content-Type":  "application/json"
                                     },
                         "body":  {
                                "description": "PS DevOps Group",
                                "displayName": "DEVOPSDEMO2",
                                "groupTypes": [
                                    "Unified"
                                ],
                                "mailEnabled": false,
                                "mailNickname": "DEVOPSDEMO2",
                                "securityEnabled": false
                                  }
                     }
                 ]
}
)
"@





$Out=Invoke-RestMethod -Headers $token_Header  -Method POST -Uri "https://graph.microsoft.com/v1.0/`$batch" -Body $JsonBody1 


$Out.responses.body.error








# GAMETIME!!!!


##
#create Users
##


##FOREACH

#AUTHENTICATION !!!!!!



#$Firstnames = @("William","David","Richard","Joseph","Thomas","Charles","Christopher","Daniel","Matthew","Anthony","Donald","Mark","Paul","Steven","Andrew","Kenneth","Joshua","George","Kevin","Brian","Edward","Ronald","Timothy","Jason","Jeffrey","Ryan","Jacob","Gary","Nicholas","Eric","Stephen","Jonathan","Larry","Justin","Scott","Brandon","Frank","Benjamin","Gregory","Samuel","Raymond","Patrick","Alexander","Jack","Dennis","Jerry","Tyler","Aaron","Jose","Henry","Adam","Douglas","Nathan","Peter","Zachary","Kyle","Walter","Harold","Jeremy","Ethan","Carl","Keith","Roger","Gerald","Christian","Terry","Sean","Arthur","Austin","Noah","Lawrence","Jesse","Joe","Bryan","Billy","Jordan","Albert","Dylan","Bruce","Willie","Gabriel","Alan","Juan","Louis","Jonathan","Wayne","Roy","Ralph","Randy","Philip","Harry","Vincent","Bobby","Johnny","Logan","Mary","Patricia","Jennifer","Linda","Elizabeth","Barbara","Susan","Jessica","Sarah","Karen","Nancy","Lisa","Betty","Dorothy","Sandra","Ashley","Kimberly","Donna","Emily","Michelle","Carol","Amanda","Melissa","Deborah","Stephanie","Rebecca","Laura","Sharon","Cynthia","Kathleen","Helen","Amy","Shirley","Angela","Anna","Ruth","Brenda","Pamela","Nicole","Katherine","Virginia","Catherine","Christine","Samantha","Debra","Janet","Carolyn","Rachel","Heather","Maria","Diane","Emma","Julie","Joyce","Frances","Evelyn","Joan","Christina","Kelly","Martha","Lauren","Victoria","Judith","Cheryl","Megan","Alice","Ann","Jean","Doris","Andrea","Marie","Kathryn","Jacqueline","Gloria","Teresa","Sara","Janice","Hannah","Julia","Rose","Theresa","Grace","Judy","Beverly","Denise","Marilyn","Amber","Danielle","Brittany","Diana","Abigail")

$FirstnamesForeach = @("Joshua","George","Kevin")
$LastnamesForeach = @("Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores", "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin", "Diaz", "Hayes", "Myers", "Ford", "Hamilton", "Graham", "Sullivan", "Wallace", "Woods", "Cole", "West", "Jordan", "Owens", "Reynolds", "Fisher", "Ellis", "Harrison", "Gibson", "Mcdonald", "Cruz", "Marshall", "Ortiz", "Gomez", "Murray", "Freeman", "Wells", "Webb", "Simpson", "Stevens", "Tucker", "Porter", "Hunter", "Hicks", "Crawford", "Henry", "Boyd", "Mason", "Morales", "Kennedy", "Warren", "Dixon", "Ramos", "Reyes", "Burns", "Gordon", "Shaw", "Holmes", "Rice", "Robertson", "Hunt", "Black", "Daniels", "Palmer", "Mills", "Nichols", "Grant", "Knight", "Ferguson", "Rose", "Stone", "Hawkins", "Dunn", "Perkins", "Hudson", "Spencer", "Gardner", "Stephens", "Payne", "Pierce", "Berry", "Matthews", "Arnold", "Wagner", "Willis", "Ray", "Watkins")

$FirstnamesForeach.Count #4
$LastnamesForeach.Count #174
#696


$countForeach = 0
#create a foreach loop to create 200 users with every possible combination of Firstname and Lastname
foreach ($Firstname in $FirstnamesForeach) {
    foreach ($Lastname in $LastnamesForeach) {
        $Username = $Firstname + "." + $Lastname
        $Password = "P@ssw0rd"
        $Email = $Username + "@au2mator.com"

        #Create the User in Azure via Graph API
        $Body = @{
            'accountEnabled'    = $false
            'displayName'       = $Firstname + " " + $Lastname
            'mailNickname'      = $Username
            'givenName'         = $Firstname
            'surname'           = $Lastname
            'userPrincipalName' = $Email
            'jobTitle'          = "DEVOPS DEMO"
            'passwordProfile'   = @{
                'forceChangePasswordNextSignIn' = $true
                'password'                      = $Password
            }
        }
        $JsonBody = ConvertTo-Json $Body

        $Out = Invoke-RestMethod -Body $JsonBody -Headers $token_Header -Method Post -Uri "https://graph.microsoft.com/v1.0/users"
        $countForeach++
    }
}

#Result Foreach
$countForeach




#build a PowerShell Array with 200 international Lastnames
$FirstnamesBatch = @("Ronald","Timothy","Jason","Paul")
$LastnamesBatch = @("Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores", "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin", "Diaz", "Hayes", "Myers", "Ford", "Hamilton", "Graham", "Sullivan", "Wallace", "Woods", "Cole", "West", "Jordan", "Owens", "Reynolds", "Fisher", "Ellis", "Harrison", "Gibson", "Mcdonald", "Cruz", "Marshall", "Ortiz", "Gomez", "Murray", "Freeman", "Wells", "Webb", "Simpson", "Stevens", "Tucker", "Porter", "Hunter", "Hicks", "Crawford", "Henry", "Boyd", "Mason", "Morales", "Kennedy", "Warren", "Dixon", "Ramos", "Reyes", "Burns", "Gordon", "Shaw", "Holmes", "Rice", "Robertson", "Hunt", "Black", "Daniels", "Palmer", "Mills", "Nichols", "Grant", "Knight", "Ferguson", "Rose", "Stone", "Hawkins", "Dunn", "Perkins", "Hudson", "Spencer", "Gardner", "Stephens", "Payne", "Pierce", "Berry", "Matthews", "Arnold", "Wagner", "Willis", "Ray", "Watkins")


$FirstnamesBatch.Count #4
$LastnamesBatch.Count #174
#696

#lets write a foreach to create every combination of $FirstnamesBatch and LastnamesBatch via Graph API and batch jobs
[hashtable]$Array = @{}
$BatchSize = 20
$BatchCount = 0
$Batch = @()
$countBatch = 0
foreach ($Firstname in $FirstnamesBatch) {
    foreach ($Lastname in $LastnamesBatch) {
        $BatchCount++
        $countBatch++

        $Username = $Firstname + "." + $Lastname
        $Email = $Username + "@au2mator.com"

        $Body = @{
            'accountEnabled'    = $false
            'displayName'       = $Username
            'mailNickname'      = $Username
            'givenName'         = $Firstname
            'surname'           = $Lastname
            'userPrincipalName' = $Email
            'jobTitle'          = "DEVOPS DEMO"
            'passwordProfile'   = @{
                'forceChangePasswordNextSignIn' = $true
                'password'                      = "P@ssw0rd"
            }
        }

        #$JsonBody = ConvertTo-Json $Body

        $Array.requests += @([ordered]@{ 
                id      = "$BatchCount";
                method  = "POST"
                url     = "/users"
                headers = @{"Content-Type" = "application/json" }
                body    = $Body
            })

        if ($BatchCount -eq $BatchSize -or $countBatch -eq ($FirstnamesBatch.Count * $LastnamesBatch.Count )) {
            $BatchJson = $Array | ConvertTo-Json -Depth 10
            $BatchResult = Invoke-RestMethod -Headers $token_Header  -Method POST -Uri "https://graph.microsoft.com/v1.0/`$batch" -Body $BatchJson 
            $BatchCount = 0
            [hashtable]$Array = @{}
        }       
    }
}

#Result Batch
$countBatch

