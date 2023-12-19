# =======================================================
# NAME: GetVmPublicIp.ps1
# AUTHOR: LEGOUPIL, Clément, Entreprise
# DATE: 19/09/2023
#
# Lists all public IPs. Takes a string with the name of the VMs you want to match in input
#
# Usage : ./GetVmPublicIp.ps1 -VmName "splunk" -export "splunkPubIps" --> output : splunkPubIps.csv
#
# =======================================================

param 
(
     [string]$VMName,
     [string]$export
)

function GetPublicIP ($VMName) {
     $publicIPs = Get-AzPublicIpAddress | where-object -Property Name -Match "$VMName"
     $publicIPs | Select-Object -Property Name, PublicIpAllocationMethod, IpAddress |Format-Table 
}

$nowDate = Get-Date -Format "dd-MM-yyyy"

if ($export -eq "CSV"){
     GetPublicIP($VMName) | Out-File -FilePath ".\pubIpsreport-$nowDate-.csv" -NoClobber
}else{
     GetPublicIP($VMName)
}

