# =======================================================
# NAME: GetRgExpiDate.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 13/02/2023
# =======================================================

$rgs = Get-AzResourceGroup
$rgTags = @()

foreach ($rg in $rgs){

    $tags = Get-AzTag -ResourceId $rg.Id
    write-host $tags.Properties.TagsProperty
    $rgTags += New-Object psobject -Property {
        "RgName" = $rg.Name
        "TagApprover" = ""
        "TagOwner" = ""
        "TagEndDate" = ""
        "Other" = 
    }
    
}