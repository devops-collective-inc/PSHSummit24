Get-WinEvent -LogName System -MaxEvents 5

Get-WinEvent -FilterHashtable @{LogName = "System"; ID = 1 } -MaxEvents 5

Get-WinEvent -LogName System `
    -FilterXPath '*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) <= 86400000]]]' `
    -MaxEvents 5




            