# =======================================================
# NAME: GetAutoShutdownStatus.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 27/02/2023
# =======================================================

# Improvments
# [x] Add tags associated for contact
# [ ] Exclude devtestlab resources

$vmliststatus = @()
$subscriptionId = az account show --query id --output tsv

foreach ($vm in Get-AzVm){
    try  {
        $shutdownresource = Get-AzResource `
                -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$($vm.ResourceGroupName)/providers/microsoft.devtestlab/schedules/shutdown-computevm-$($vm.Name)" `
                -ErrorAction Stop

        $vmliststatus += New-Object psobject -Property @{
                "VMName" = $vm.Name
                "ShutdownStatus" = $shutdownResource.Properties.status
                "Tags" = $vm.Tags
        }
    }
    catch {
        $vmliststatus += New-Object psobject -Property @{
                "VMName" = $vm.Name
                "ShutdownStatus" = "Not configured"
                "Tags" = $vm.Tags
        }

    }
    
}

$vmliststatus

