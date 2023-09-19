# =======================================================
# NAME: GetVmPublicIp.ps1
# AUTHOR: FAVROT, Jean-Baptiste, Entreprise
# DATE: 31/05/2022
#
# Lists all VMs with corresponding public IPs. Takes a string with the name of the VMs you want to match in input
#
# Usage : ./GetVmPublicIp.ps1 "splunk" "splunkPubIps" --> output : splunkPubIps.csv
#
# =======================================================

param 
(
     [string]$VMName,
     [string]$CSV
)

function GetPublicIP ($VMName) {
     $publicIPs = Get-AzPublicIpAddress | where-object -Property Name -Match "$VMName"
     
     foreach($publicIP in $publicIPs) {
          $publicIP | Select-Object -Property Name, PublicIpAllocationMethod, IpAddress |Format-Table 
         }
}

$nowDate = Get-Date -Format "dd-MM-yyyy"

if ($CSV -eq "CSV"){
     GetPublicIP($VMName) | Out-File -FilePath ".\pubIpsreport-$nowDate-.csv" -NoClobber
}else{
     GetPublicIP($VMName)
}

