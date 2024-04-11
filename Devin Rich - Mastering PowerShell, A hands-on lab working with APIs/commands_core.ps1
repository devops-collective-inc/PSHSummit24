

Invoke-RestMethod https://summit.dcrich.net/api/dinosaur


Invoke-WebRequest https://summit.dcrich.net/api/dinosaur


Invoke-RestMethod https://summit.dcrich.net/api/dinosaur -Method Post


$Error[0].exception


try {
    Invoke-RestMethod https://summit.dcrich.net/api/dinosaur -Method Post
}
catch {
    $_.exception.message
}


try {
    Invoke-RestMethod https://summit.dcrich.net/api/dinosaur -Method Post
}
catch {
    $_.exception.response.statuscode
}


try {
    Invoke-RestMethod https://summit.dcrich.net/api/dinosaur -Method Post
}
catch {
    $_.exception.response.statuscode -as [int]
}


Invoke-RestMethod https://summit.dcrich.net/api/statuscode


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/200


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/300


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/400


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/500


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/418


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/418 -MaximumRetryCount 1 -RetryIntervalSec 5


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/418 -MaximumRetryCount 1 -RetryIntervalSec 5


Invoke-RestMethod https://summit.dcrich.net/api/statuscode/429 -MaximumRetryCount 1 -RetryIntervalSec 5


Invoke-RestMethod https://summit.dcrich.net/api/request


Invoke-RestMethod https://summit.dcrich.net/api/request -Method -Body @{"Name" = "Devin" }


Invoke-RestMethod https://summit.dcrich.net/api/request -Method Post -Body @{"Name" = "Devin" }


Invoke-RestMethod https://summit.dcrich.net/api/request | Select-Object -ExpandProperty headers


Invoke-RestMethod https://summit.dcrich.net/api/request -Headers @{accept = "application/json" }
| Select-Object -ExpandProperty headers


Invoke-RestMethod https://summit.dcrich.net/api/user_password -Authentication Basic -Credential (Get-Credential)


Invoke-RestMethod https://summit.dcrich.net/api/user_password -Authentication Basic -Credential (Get-Credential)


Invoke-RestMethod https://summit.dcrich.net/api/user_key?api_key=$(Get-Clipboard)


Invoke-RestMethod https://summit.dcrich.net/api/user_bearer -Authentication Bearer -Token LiHq2DPQIkF94ouXMSB75UTYnn7ddVhqzccuzcjT0IEWiRC7SEdfgOKI7pPk6D0XtgHq3c4uzJSJ9rOJrNEWIJ0CzwbG4NzC7RqOW4RwdHxBRKJM2ndjh8UIB1T1okoK0TqoQ5JDxMnd4JPMn9j5PsqhnUNgHtISOIEkSbOcGGfBPjYZFxxHNmt65JjWkoZJ4Wp5RrUDDYuLHmbLsFY9UfcuOkUvdXyIQHxUk0sVZg0QF0H5fDefPiLnh1RK1i6A


$bear = Read-Host -AsSecureString


$bear


Invoke-RestMethod https://summit.dcrich.net/api/user_bearer -Authentication Bearer -Token $bear


Invoke-RestMethod https://summit.dcrich.net/api/account


Invoke-RestMethod https://summit.dcrich.net/api/account?page=2


Invoke-RestMethod https://summit.dcrich.net/api/account?page=4


Invoke-RestMethod https://summit.dcrich.net/api/account?page=5


Invoke-RestMethod https://summit.dcrich.net/api/account?page=5 | Format-List



$response = $null
$array = do {
    $response = Invoke-RestMethod https://summit.dcrich.net/api/account?page=$($response.next)
    $response.data
} while ($response.next)


$array


$array.Count


Invoke-RestMethod https://pokeapi.co/api/v2/pokemon


Invoke-RestMethod https://pokeapi.co/api/v2/pokemon | Format-List


$response = Invoke-RestMethod https://pokeapi.co/api/v2/pokemon


$response.results.count


$response = Invoke-RestMethod https://pokeapi.co/api/v2/pokemon?limit=100


$response.results.count


$uri = "https://pokeapi.co/api/v2/pokemon?limit=100"
$array = while ($uri) {
    $response = Invoke-RestMethod $uri
    $uri = $response.next
    $response.results
    Write-Host -NoNewline "."
}


$array[0]


$array.count


Invoke-RestMethod "https://discord.com/api/webhooks/1115855344103591946/nr1OLf7FcZJ3orLzhBWd3nBFq_F0p2QdE3-Zr0n5slbtR6YKHbn7buYp5RMTut-R_SoT" -Method Post -Body @{
    content = "Hello World"
}


Invoke-RestMethod "https://discord.com/api/webhooks/1115855344103591946/nr1OLf7FcZJ3orLzhBWd3nBFq_F0p2QdE3-Zr0n5slbtR6YKHbn7buYp5RMTut-R_SoT" -Method Post -Body @{
    content  = "Hello World"
    username = "Darth Vader"
}

