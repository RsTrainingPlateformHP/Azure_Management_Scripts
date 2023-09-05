# =======================================================
# 
# NAME: delete_ressource_RG.ps1
# AUTHOR: PRODHOMME, Romaric, Entreprise
# DATE: 25/04/2023
#
# Prend une regex en paramètre
# récupère tous les noms de RG correspondant à la regex
# supprime toutes les ressources des RG
#
# =======================================================

param(
    [string]$args1
)

# Récupération des RG
$resourceGroups = Get-AzResourceGroup | Select-Object ResourceGroupName
$resourceGroupNames = $resourceGroups | Where-Object { $_.ResourceGroupName -match $args1 }

Write-Host "Resource Groups that will be deleted:"
$resourceGroupNames.ResourceGroupName

# On check les RG et on Continue/Stop le script
$continue = Read-Host "Are you sure ? Yes | No"
if ($continue -eq "Yes") {
    Write-Host "Continue..."
} else {
    Write-Host "Exit."
    exit 1
}

# Parcourir chaque groupe de ressources pour supprimer les ressources
foreach ($resourceGroupName in $resourceGroupNames) {

    # Récupérer toutes les ressources du groupe de ressources
    $resources = Get-AzResource -ResourceGroupName $resourceGroupName.ResourceGroupName

    # Supprimer chaque ressource
    foreach ($resource in $resources) {
        Remove-AzResource -ResourceId $resource.ResourceId -Force -asjob
    }
}
