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

Write-Host $resourceGroupNames

# On check les RG et on Continue/Stop le script
$continue = Read-Host "Voulez-vous bien supprimer les ressources des RG suivants: $resourceGroupNames (Oui / Non)"
if ($continue -eq "Oui") {
    Write-Host "Continuer..."
} else {
    Write-Host "Arrêter."
    exit 1
}

# Parcourir chaque groupe de ressources et supprimer toutes les ressources
foreach ($resourceGroupName in $resourceGroupNames) {

    Write-Host $resourceGroupName.ResourceGroupName

    # Récupérer toutes les ressources du groupe de ressources
    $resources = Get-AzResource -ResourceGroupName $resourceGroupName.ResourceGroupName

    # Supprimer chaque ressource
    foreach ($resource in $resources) {
        Write-Host "Ma ressource est: $resource"
        Remove-AzResource -ResourceId $resource.ResourceId -Force
    }
}