
$podeWedPage_params = @{
    Name             = 'RegisterComplete'
    Icon             = 'Activity'
    NoAuthentication = $true
    NoSidebar        = $true
    NoTitle          = $true
    NoBreadcrumb     = $true
    Hide             = $true
    ScriptBlock      = {
        New-PodeWebCard -CssStyle @{"max-width" = "800px"; margin = 'auto' } -NoHide -Content @(
            New-PodeWebHeader -Id a -Size 1 -Value "Account created!"
            New-PodeWebButton -Name 'Login' -CssStyle @{"max-width" = "800px"; margin = 'auto' } -ScriptBlock {
                Move-PodeWebUrl -Url /
            }
        )
    }
}
Add-PodeWebPage @podeWedPage_params -PassThru | Register-PodeWebPageEvent -Type Load -ScriptBlock {
    Show-PodeWebToast -Message 'Account created. You may now login.' -Duration 3000
}



$podeWedPage_params = @{
    Name             = 'Register'
    Icon             = 'Settings'
    NoAuthentication = $true
    NoSidebar        = $true
    NoTitle          = $true
    NoBreadcrumb     = $true
    Hide             = $true
    ScriptBlock      = {
        New-PodeWebHeader -Id a -Size 1 -Value "Create a local, temporary, dummy account" -CssStyle @{"max-width" = "800px"; margin = 'auto' }
        New-PodeWebLine -Id b -CssStyle @{"max-width" = "800px" }

        $podeWebForm_params = @{
            Name        = 'Demo'
            CssStyle    = @{"max-width" = "800px"; margin = 'auto' }
            ShowReset   = $true
            ResetText   = 'Clear'

            Content     = @(
                New-PodeWebTextbox -Required -Name 'Username'

                New-PodeWebTextbox -Name 'Name' -HelpText "Suggestions available" -AutoComplete {
                    return @(
                        "Indiana Jones", "James Bond", "Luke Skywalker", "Hannibal Lecter", "Forrest Gump",
                        "Rocky Balboa", "Ellen Ripley", "Frodo Baggins", "Darth Vader", "Neo",
                        "Jack Dawson", "Harry Potter", "Katniss Everdeen", "Iron Man", "Captain Jack Sparrow",
                        "The Joker", "Wonder Woman", "Marty McFly", "James T. Kirk", "Vito Corleone",
                        "Clarice Starling", "Jason Bourne", "Maximus Decimus Meridius", "Atticus Finch", "Don Vito Corleone",
                        "Michael Corleone", "Sulley", "Buzz Lightyear", "Ethan Hunt", "John McClane",
                        "Rick Blaine", "Princess Leia", "Sarah Connor", "John Wick", "Tony Montana",
                        "Jack Sparrow", "Shrek", "Inigo Montoya", "Westley", "Ferris Bueller",
                        "Randle McMurphy", "E.T.", "T-800 (Terminator)", "Norman Bates", "John Rambo",
                        "Edward Scissorhands", "Jules Winnfield", "Vincent Vega", "Tyler Durden", "Albus Dumbledore",
                        "Sherlock Holmes", "Jay Gatsby", "Aragorn", "Legolas", "Hermione Granger",
                        "Jack Torrance", "Danny Ocean", "Erin Brockovich", "Marge Gunderson", "William Wallace",
                        "Danny Zuko", "Tony Manero", "Carrie Bradshaw", "Ferris Bueller", "Shosanna Dreyfus",
                        "Django", "Walter White", "Jesse Pinkman", "Tony Soprano", "Walter Sobchak",
                        "The Dude", "Beatrix Kiddo", "Jigsaw", "Gollum/Smeagol", "Aibileen Clark",
                        "Minny Jackson", "Dom Cobb", "Arlo (The Good Dinosaur)", "Wall-E", "Lightning McQueen",
                        "Marlin and Dory", "Anton Chigurh", "R.J. MacReady", "Carlitos Brigante", "Carl Fredricksen",
                        "Mr. Darcy", "Elizabeth Bennet", "Logan (Wolverine)", "Hermione Granger", "Arwen",
                        "Jack Skellington", "Sally (The Nightmare Before Christmas)", "Wally (WALL-E)", "Tony Stark (Endgame)",
                        "Jules Winnfield", "Vincent Vega", "Selene (Underworld)", "Captain America (Steve Rogers)", "Black Widow (Natasha Romanoff)",
                        "Deadpool", "Ellie (Up)", "Carl (Up)", "Merida (Brave)", "Woody (Toy Story)", "Buzz Lightyear (Toy Story)",
                        "Sid (Toy Story)", "WALL-E", "Eve (WALL-E)", "Remy (Ratatouille)", "Mia Thermopolis (The Princess Diaries)",
                        "Shrek", "Donkey (Shrek)", "Fiona (Shrek)", "Puss in Boots (Shrek)", "Hiccup (How to Train Your Dragon)",
                        "Toothless (How to Train Your Dragon)", "Po (Kung Fu Panda)", "Shifu (Kung Fu Panda)", "Mulan",
                        "Mushu (Mulan)", "Simba (The Lion King)", "Mufasa (The Lion King)", "Scar (The Lion King)",
                        "Nala (The Lion King)", "Rafiki (The Lion King)", "Timon and Pumbaa (The Lion King)", "Elsa (Frozen)",
                        "Anna (Frozen)", "Olaf (Frozen)", "Kristoff (Frozen)", "Sully (Monsters, Inc.)",
                        "Mike Wazowski (Monsters, Inc.)", "Boo (Monsters, Inc.)", "Marlin (Finding Nemo)", "Dory (Finding Nemo)",
                        "Nemo (Finding Nemo)", "Gru (Despicable Me)", "Minions (Despicable Me)", "Agnes (Despicable Me)",
                        "Lucy (Despicable Me)", "Edna Mode (The Incredibles)", "Mr. Incredible (The Incredibles)", "Elastigirl (The Incredibles)",
                        "Dash (The Incredibles)", "Violet (The Incredibles)", "Syndrome (The Incredibles)", "Remy (Ratatouille)",
                        "Linguini (Ratatouille)", "Russell (Up)", "Doug (Up)", "Carl (Up)", "Moana",
                        "Aladdin", "Jasmine", "Genie", "Simba (The Lion King)", "Timon and Pumbaa (The Lion King)",
                        "Nala (The Lion King)", "Rafiki (The Lion King)", "Zazu (The Lion King)", "Scar (The Lion King)",
                        "Mushu (Mulan)", "Cri-Kee (Mulan)", "Shang (Mulan)", "Baloo (The Jungle Book)", "Bagheera (The Jungle Book)",
                        "Mowgli (The Jungle Book)", "Shere Khan (The Jungle Book)", "King Louie (The Jungle Book)", "Cinderella",
                        "Fairy Godmother (Cinderella)", "Prince Charming (Cinderella)", "Lady Tremaine (Cinderella)", "Jaq and Gus (Cinderella)",
                        "Alice (Alice in Wonderland)", "Mad Hatter (Alice in Wonderland)", "Queen of Hearts (Alice in Wonderland)", "Cheshire Cat (Alice in Wonderland)",
                        "Ariel (The Little Mermaid)", "Ursula (The Little Mermaid)", "Flounder (The Little Mermaid)", "King Triton (The Little Mermaid)",
                        "Beast (Beauty and the Beast)", "Belle (Beauty and the Beast)", "Gaston (Beauty and the Beast)", "Lumière (Beauty and the Beast)",
                        "Cogsworth (Beauty and the Beast)"
                    )
                }
                New-PodeWebTextbox -Required -Name 'Password' -Type Password -PrependIcon Lock
                $opt = [ordered]@{
                    "N/A"         = "No response"
                    "Learning"    = "I'm here to learn"
                    "Extending"   = "I can extend scripts and snippets"
                    "Building"    = "I make solutions for others"
                    "Presenting"  = "I'm presenting aren't I?"
                    "Pretentious" = "I am the matrix"
                }
                New-PodeWebRadio -Name 'PowerShell Experience Level' -Options $opt.keys.ForEach{ $_ } -DisplayOptions $opt.values.ForEach{ $_ }

                $opt = [ordered]@{
                    "N/A"         = "No response"
                    "Learning"    = "I'm here to learn"
                    "Confident"   = "I am fine with them"
                    "Building"    = "I make APIs"
                    "Pretentious" = "I make APIs for fun"
                }
                New-PodeWebRadio -Name 'API Experience Level' -Options $opt.keys.ForEach{ $_ } -DisplayOptions $opt.values.ForEach{ $_ }

                $opt = [ordered]@{
                    "N/A"     = "None of these"
                    "Cloud"   = "Cloud native"
                    "Hybrid"  = "Hybrid azure domain"
                    "On-prem" = "On-prem only"
                    "Decline" = "Decline to answer"
                }
                New-PodeWebRadio -Name 'Work azure environment' -Options $opt.keys.ForEach{ $_ } -DisplayOptions $opt.values.ForEach{ $_ }
            )


            ScriptBlock = {
                $tb_Account = Get-PodeState -Name tb_Account

                $invalid = $false
                if (Get-AzDataTableEntity -Context $tb_Account -Filter "RowKey eq '$($WebEvent.Data['Username'])'") {
                    Out-PodeWebValidation -Name 'Username' -Message "Username '$($WebEvent.Data['Username'])' is already taken. Please try a different Username."
                    $invalid = $true
                }
                if ($invalid) {
                    return
                }


                function ConvertTo-SHA256([string]$String) {
                    $SHA256 = New-Object System.Security.Cryptography.SHA256Managed
                    $SHA256Hash = $SHA256.ComputeHash([Text.Encoding]::ASCII.GetBytes($String))
                    $SHA256HashString = [Convert]::ToBase64String($SHA256Hash)
                    return $SHA256HashString
                }
                $obj = [PSCustomObject]@{
                    PartitionKey = ''
                    RowKey       = $WebEvent.Data['Username']
                    Username     = $WebEvent.Data['Username']
                    Name         = $WebEvent.Data['Name']
                    Password     = $WebEvent.Data['Password']
                    Experience   = $WebEvent.Data['PowerShell Experience Level']
                    API          = $WebEvent.Data['API Experience Level']
                    Environment  = $WebEvent.Data['Work azure environment']
                    Key          = -join (1..52 | ForEach-Object { 'a'..'z' + 'A'..'Z' + 0..9 | Get-Random })
                    Bearer       = -join (1..256 | ForEach-Object { 'a'..'z' + 'A'..'Z' + 0..9 | Get-Random })
                    Basic        = 0
                    ApiKey       = 0
                    OAuth        = 0
                    Quote        = 0
                }
                Write-Warning "new user created!"
                Add-AzDataTableEntity -Context $tb_Account -Entity $obj

                Move-PodeWebUrl -Url /pages/RegisterComplete
            }
        }
        New-PodeWebForm @podeWebForm_params
    }
}
Add-PodeWebPage @podeWedPage_params



# {
#     "Username": "devin",
#     "Name": "Devin",
#     "Password": "j0NDRmSPa5bfid2pAcUXaxCm2Dlh3TwayItZstwyeqQ="
# }
#
