# =======================================================
# NAME: GetRgExpiDate.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 13/02/2023
# =======================================================

$rgs = Get-AzResourceGroup
$rgTags = @()

foreach ($rg in $rgs){

    $tags = Get-AzTag -ResourceId $rg.ResourceId
    if ($tags) {
        $rgTags += New-Object psobject -Property @{
            "RgName" = $rg.Name
            "Tags"   = $tags.Properties.TagsProperty
        }
    }else{
    $rgTags += New-Object psobject -Property @{
        "RgName" = $rg.Name
        "Tags"   = "None"
    
    }  
}
}

$rgTags
