# =======================================================
# NAME: GetVmPublicIp.ps1
# AUTHOR: FAVROT, Jean-Baptiste, Entreprise
# DATE: 31/05/2022
#
# Lists all VMs with corresponding public IPs. Takes a string with the name of the VMs you want to match in input
#
# =======================================================

param ($VMName)

$publicIPs = Get-AzPublicIpAddress | where-object -Property Name -Match "$VMName"

foreach($publicIP in $publicIPs) {
     Write-Output "$($publicIP.ResourceGroupName) - $($publicIP.Name) : $($publicIP.IpAddress)"
    }