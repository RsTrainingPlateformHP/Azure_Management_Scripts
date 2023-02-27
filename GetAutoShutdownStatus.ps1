# =======================================================
# NAME: GetAutoShutdownStatus.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 27/02/2023
# =======================================================

#
# Add tags associated for contact
#

$vmliststatus = @()

foreach ($vm in Get-AzVm){
    try  {
        $subscriptionId = ($vm.Id -split "/")[2]
        $shutdownresource = Get-AzResource `
                -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$($vm.ResourceGroupName)/providers/microsoft.devtestlab/schedules/shutdown-computevm-$($vm.Name)" `
                -ErrorAction Stop

        if ("hidden-DevTestLabs-LogicalResourceUId" in $vm.Tags){
            write-host "catch devtestlab"
        }

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

