# =======================================================
# 
# NAME: delete_ressource_RG.ps1
# AUTHOR: PRODHOMME, Romaric, Entreprise
# DATE: 25/04/2023
#
# Check toutes les ressources dans Azure pour regarder
# la endDate. Si elle est dépassé on retourne le 
# nom de ressource, groupe de ressourde et owner
#
# =======================================================


# Récupérer toutes les ressources dans votre abonnement Azure
$resources = Get-AzResource

# Parcourir toutes les ressources et vérifier la balise "endDate"
foreach ($resource in $resources) {
    $tags = $resource.Tags
    if ($tags -ne $null -and $tags.ContainsKey("endDate")) {
        $endDateString = $tags["endDate"]
        $endDate = $null
        if ([DateTime]::TryParse($endDateString, [ref]$endDateString)) {
            if ($endDateString -lt [DateTime]::Now) {
                # La balise "endDate" est dépassée
                $resourceGroup = $resource.ResourceGroupName
                $owner = $tags["owner"]
                $endDateFormatted = $endDate.ToString("yyyy-MM-dd")
                Write-Host "Ressource dépassée: $($resource.Name), Groupe de ressources: $($resourceGroup), Owner: $($owner), Date de fin: $($endDateFormatted)"
            }
        }
    }
}
