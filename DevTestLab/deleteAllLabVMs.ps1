# =======================================================
# NAME: deleteAllLabVMs.ps1
# AUTHOR: FAVROT, Jean-Baptiste, Entreprise
# DATE: 31/05/2022
#
#Takes a lab resource ID in input and launches delete commands as jobs for all VMs in the lab.
#
# =======================================================


param ([Parameter(Mandatory)][ValidatePattern('\/subscriptions\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/resourcegroups\/[a-z_\-.()]{1,90}\/providers\/microsoft.devtestlab\/labs\/[a-z_\-.()]{1,90}')][string]$LabResourceId)

$lab = Get-AzResource -ResourceId $LabResourceId 

$labVMs = Get-AzResource | Where-Object {$_.ResourceType -eq 'microsoft.devtestlab/labs/virtualmachines' -and $_.Name -like "$($lab.Name)/*"}

foreach($labVM in $labVMs) { Remove-AzResource -ResourceId $labVM.ResourceId -Force -asjob }
