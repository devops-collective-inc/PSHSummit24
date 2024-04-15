#region disk usage
$DiskSize =  (snmpwalk -v2c -c public 172.16.115.160 '.1.3.6.1.2.1.25.2.3.1.5.1').Split(' ')[-1]
$DiskUsed = (snmpwalk -v2c -c public 172.16.115.160 '.1.3.6.1.2.1.25.2.3.1.6.1').Split(' ')[-1]

$usedPercent = [math]::Round(($DiskUsed / $DiskSize),2) * 100
$available = 100 - $usedPercent

[pscustomobject]@{
    Used = "$usedPercent %"
    Free = "$available %"
}
#endregion

#region server uptime
snmpwalk -v2c -c public  -On 172.16.115.160 1.3.6.1.2.1.25.1
#endregion

#region printer demo things. Skip running cause this won't work due to network constraints.

#Drum Unit life
$remaining = '.1.3.6.1.2.1.43.11.1.1.9.1.2'
$capacity = '.1.3.6.1.2.1.43.11.1.1.8.1.2'

$lifeRemaining = (Start-Snmpwalk -Version 1 -Community public -Target 192.168.1.20 -Oid $remaining)
$totalCapacity = (Start-Snmpwalk -Version 1 -Community public -Target 192.168.1.20 -oid $capacity)

([Math]::Round(($lifeRemaining.Value / $totalCapacity.value),2)) * 100
#endregion