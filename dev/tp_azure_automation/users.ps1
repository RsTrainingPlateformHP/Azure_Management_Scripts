# goal
# 1- fetch users with identifier
# 2- associate users to groups (if 18<= 1 par group, sinon 2 par groupes)

# Rechercher des utilisateurs dont l'identifiant commence par '123'
$prefix = "cl"
$users = az ad user list --filter "startswith(userPrincipalName, '$prefix')" | ConvertFrom-Json

# Liste des groupes de ressources
$resourceGroups = 1..18 | ForEach-Object { "RG_TP_Azure_{0:D2}" -f $_ }

# Répartir les utilisateurs dans les groupes de ressources
$groupedUsers = @{}

foreach ($user in $users) {
    $index = ($users.IndexOf($user)) % $resourceGroups.Count
    $resourceGroupName = $resourceGroups[$index]
    
    if (-not $groupedUsers.ContainsKey($resourceGroupName)) {
        $groupedUsers[$resourceGroupName] = @()
    }

    $groupedUsers[$resourceGroupName] += $user
}

# Afficher les utilisateurs par groupe de ressources
foreach ($group in $groupedUsers.Keys) {
    Write-Host "Utilisateurs dans le groupe de ressources $group:"
    $groupedUsers[$group] | Format-Table UserPrincipalName, DisplayName
}
