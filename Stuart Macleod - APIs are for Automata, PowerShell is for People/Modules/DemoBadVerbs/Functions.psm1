function Invoke-Thing {
    Write-Host "Function called: $($MyInvocation.Line)"
}

function Do-Thing {
    Write-Host "Function called: $($MyInvocation.Line)"
}