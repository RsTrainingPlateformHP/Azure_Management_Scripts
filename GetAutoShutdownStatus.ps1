# =======================================================
# NAME: GetAutoShutdownStatus.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 27/02/2023
# =======================================================

$vmliststatus = @()

foreach ($vm in Get-AzVm){
    try  {
        $subscriptionId = ($vm.Id -split "/")[2]
        $shutdownresource = Get-AzResource `
                -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$($vm.ResourceGroupName)/providers/microsoft.devtestlab/schedules/shutdown-computevm-$($vm.Name)" `
                -ErrorAction Stop

        $vmliststatus += New-Object psobject -Property @{
                "VMName" = $vm.Name
                "ShutdownStatus" = $shutdownResource.Properties.status
        }
    }
    catch {
        $vmliststatus += New-Object psobject -Property @{
                "VMName" = $vm.Name
                "ShutdownStatus" = "Not existing"
        }

    }
    
}

$vmliststatus

