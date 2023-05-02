# =======================================================
# 
# NAME: delete_ressource_RG.ps1
# AUTHOR: PRODHOMME, Romaric, Entreprise
# DATE: 25/04/2023
#
# Takes ressources group in input and delete all the 
# ressources inside this RG. You can select as many RG 
# as you want
#
# =======================================================


param(
    [string]$args1
)

Write-Host "Args1: $args1"

# Récupération des RG à supprimer
$resourceGroups = Get-AzResourceGroup | Select-Object ResourceGroupName
$regex = $args1
$filteredResourceGroups = $resourceGroups | Where-Object { $_.ResourceGroupName -match $regex }
$filteredResourceGroups.ResourceGroupName

$ressourceGroupNames = $filteredResourceGroups

# On check les RG et on Continue/Stop le script
$continue = Read-Host "Voulez-vous bien supprimer les ressources des RG suivants: $ressourceGroupNames (Oui / Non)"
if ($continue -eq "Oui") {
    Write-Host "Continuer..."
} else {
    Write-Host "Arrêter."
    exit 1
}

# Parcourir chaque groupe de ressources et supprimer toutes les ressources
foreach ($resourceGroupName in $resourceGroupNames) {
    # Récupérer toutes les ressources du groupe de ressources
    $resources = Get-AzResource -ResourceGroupName $resourceGroupName

    # Supprimer chaque ressource
    foreach ($resource in $resources) {
        Remove-AzResource -ResourceId $resource.ResourceId -Force
    }

    # Supprimer le groupe de ressources
    Remove-AzResourceGroup -Name $resourceGroupName -Force
}