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

# Récupérer toutes les ressources dans votre abonnement Azure
$resources = Get-AzResource

# Parcourir toutes les ressources et vérifier la balise "endDate"
foreach ($resource in $resources) {
    $tags = $resource.Tags
    if ($tags -ne $null -and $tags.ContainsKey("endDate")) {
        $endDate = [DateTime]::Parse($tags["endDate"])
        if ($endDate -lt [DateTime]::Now) {
            # La balise "endDate" est dépassée
            $resourceGroup = $resource.ResourceGroupName
            $owner = $tags["owner"]
            Write-Host "Ressource dépassée: $($resource.Name), Groupe de ressources: $($resourceGroup), Owner: $($owner)"
        }
    }
}