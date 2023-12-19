# goal
# 1- fetch users with identifier
# 2- associate users to groups (if 18<= 1 par group, sinon 2 par groupes)

# Rechercher des utilisateurs dont l'identifiant commence par '123'
$identifier = "cl"
$users = Get-AzureADUser -Filter "startswith(UserPrincipalName,'$($identifier)')"

# Afficher les résultats
$users | Format-Table UserPrincipalName, DisplayName
