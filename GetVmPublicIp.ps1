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
     [string][Parameter(Mandatory)]$OutputName
)

function GetPublicIP ($VMName) {
     $publicIPs = Get-AzPublicIpAddress | where-object -Property Name -Match "$VMName"

     Write-Output 'Resource Group,Public IP Name,Public IP Address'
     
     foreach($publicIP in $publicIPs) {
          Write-Output "$($publicIP.ResourceGroupName),$($publicIP.Name),$($publicIP.IpAddress)"
         }
}

$ipslist = GetPublicIP($VMName)

write-host $ipslist

$ipslist | Out-File -FilePath ".\$OutputName.csv" -NoClobber
