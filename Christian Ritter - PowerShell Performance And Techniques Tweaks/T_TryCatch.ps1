#region Simple Error Handling, long time ago
Get-Childitem -Path C:\DoesNotExist
if($?){
    Write-Host "It exists"
    #go ahead and do something
}else{
    Write-Host "Duh, it doesn't exist"
    return
}

#endregion

#region Try Catch
try {
    Get-Childitem -Path C:\DoesNotExist
    Write-Host "It exists"
    #go ahead and do something
} catch {
    Write-Host "Duh, it doesn't exist"
    return
}
#endregion

#region nothing to hide here, really!!!

$ErrorActionPreference

#endregion

#region Try Catch with Finally

try {
    Get-Childitem -Path C:\DoesNotExist
    Write-Host "It exists"
    #go ahead and do something
} catch {
    Write-Host "Duh, it doesn't exist"
    return
} finally {
    Write-Host "I'm done"
}

#endregion

#region Try Catch with Finally and ErrorAction

try {
    Get-Childitem -Path C:\DoesNotExist -ErrorAction Stop
    Write-Host "It exists"
    #go ahead and do something
} catch {
    Write-Host "Duh, it doesn't exist"
    return
} finally {
    Write-Host "I'm done"
}

#endregion

#region Try Catch with Finally and ErrorAction and handeling the error

try {
    Get-Childitem -Path C:\DoesNotExist -ErrorAction Stop
    Write-Host "It exists"
    #go ahead and do something
} catch {
    Write-Host "Duh, it doesn't exist"
    Write-Host "Error was: $($_.Exception.Message)" #could be sent to a log file or database
    return
} finally {
    Write-Host "I'm done"
}
write-host "catch me if u can"
#endregion

#region Try Catch with Finally and Error classification

try {
    1/0
    ##Get-Childitem -Path C:\DoesNotExist -ErrorAction Stop
    Write-Host "It exists"
    #go ahead and do something
} catch [System.Management.Automation.ItemNotFoundException] {
    Write-Host "Duh, it doesn't exist"
    return
} catch {
    Write-Host "There was an error"
    return
} finally {
    Write-Host "I'm done"
}

#endregion

#region how to find the class of the error / exception

Get-Childitem -Path C:\DoesNotExist
$Error[0].Exception.GetType().FullName

#endregion

#region Real world example: TMP files

try {
    $tempFile = new-temporaryfile 
    throw 'something really bad has happened! Danger'
}
catch {
    Write-Host "I tried so hard and got so far..."
    return
}finally{
    $tempFile | remove-item -Force
}

# kill DB Connection and/or Connection to API like Graph

#endregion