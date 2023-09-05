param ([Parameter(Mandatory)][string]$patternRG)

$subscriptionId = az account show --query id --output tsv



#$patternRG = "Training_Labs-TP-CIS-Win"

$Rgs = Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -like "$($patternRG)*"}

write-host "Here is the list of Resource Groups you want to delete:"
foreach ($rg in $Rgs){
    write-host $rg.ResourceGroupName
}
$confirmation = Read-Host "Do you want to delete $($Rgs.count) [y/n] ?"
if ($confirmation -eq 'n') {
    exit
}

foreach ($rg in $Rgs){
    $counter++
    write-progress -Activity 'Processing Vms' -Status "Processing $($counter) of $($Rgs.count) - ($($rg.ResourceGroupName))" -CurrentOperation $rg.ResourceGroupName -PercentComplete (($counter / $Rgs.count)*100)
    Remove-AzResourceGroup -Name "$($rg.ResourceGroupName)" -AsJob -Force
}

write-host "$($Rgs.count) Resource groups has been deleted."
#Remove-AzResource -ResourceId 

#/subscriptions/a4038696-ce0f-492d-9049-38720738d4fe/resourceGroups/Training_Labs-TP-CIS-Win042-972040
