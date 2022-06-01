param ($VMName)

$publicIPs = Get-AzPublicIpAddress | where-object -Property Name -Match "$VMName"

foreach($publicIP in $publicIPs) {
     Write-Output "$($publicIP.ResourceGroupName) - $($publicIP.Name) : $($publicIP.IpAddress)"
    }