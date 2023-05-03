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

Write-Host "Liste des RG ou les ressources seront supprimés:"
$resourceGroupNames.ResourceGroupName

# On check les RG et on Continue/Stop le script
$continue = Read-Host "Etes vous d'accord: OUI | NON"
if ($continue -eq "OUI") {
    Write-Host "Continuer..."
} else {
    Write-Host "Arrêter."
    exit 1
}

# Parcourir chaque groupe de ressources pour supprimer les ressources
foreach ($resourceGroupName in $resourceGroupNames) {

    # On récupère toutes les VM du RG pour les supprimer en premier (éviter les erreurs)
    $vms = Get-AzVM -ResourceGroupName $resourceGroupName.ResourceGroupName

    # On les arrête toute et on les supprime
    foreach ($vm in $vms) {
        Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Force
        Remove-AzVM -ResourceGroupName $resourceGroupName -Name $vm.Name -Force
    }

    # Récupérer toutes les ressources du groupe de ressources
    $resources = Get-AzResource -ResourceGroupName $resourceGroupName.ResourceGroupName

    # Supprimer chaque ressource
    foreach ($resource in $resources) {
        Remove-AzResource -ResourceId $resource.ResourceId -Force
    }
}