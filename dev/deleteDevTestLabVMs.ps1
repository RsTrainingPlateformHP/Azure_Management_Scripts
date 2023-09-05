param ([Parameter(Mandatory)][string]$patternRG)


# Get devtestlab VMS
# Filter on VMs with the pattern wanted
# Validate VMs to delete
# For each VM to delete with ID, fetch RG.Name, delete VM + delete RG right after
$subscriptionId = az account show --query id --output tsv
$labResourceGroup = "rg_devtest_lab"
$labName = "Training_Labs"

$lab = Get-AzResource -ResourceId ('subscriptions/' + $subscriptionId + '/resourceGroups/' + $labResourceGroup + '/providers/Microsoft.DevTestLab/labs/' + $labName)
$labVMs = Get-AzResource | Where-Object {$_.ResourceType -eq 'microsoft.devtestlab/labs/virtualmachines' -and $_.Name -like "$($lab.Name)/$($patternRG)*"}

$labVMs.Name
$confirmation = Read-Host "Delete $($labVMs.count) RGs ? [y/n]"
if ($confirmation -eq 'n') {
    exit
}

foreach ($labVM in $labVMs){
    $counter++
    write-progress -Activity 'Processing Vms' -Status "Processing $($counter) of $($labVMs.count) - ($($labVM.Name))" -CurrentOperation $labVM.Name -PercentComplete (($counter / $labVMs.count)*100)
    Remove-AzResource -ResourceId $labVM.ResourceId -asJob -Force
}

$rgname = Get-AzResourceGroup -Name $patternRG

Write-Output "Would you like to delete those Resource Groups ?"
$rgname.ResourceGroupName

$confirmation = Read-Host "Delete $($rgname.count) RG ? [y/n]"

if ($confirmation -eq 'y') {
    foreach ($rgtodelete in $rgname.ResourceGroupName){

        $counter++
        write-progress -Activity 'Processing Vms' -Status "Processing $($counter) of $($rgname.count) - ($($rgname.ResourceGroupName))" -CurrentOperation $rgtodelete -PercentComplete (($counter / $rgname.count)*100)
        Remove-AzResourceGroup -Name $rgtodelete -Force -asJob
    }
}
