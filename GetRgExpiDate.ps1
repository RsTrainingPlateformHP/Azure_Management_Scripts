# =======================================================
# NAME: GetRgExpiDate.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 13/02/2023
# =======================================================
param(
    [string]$arg1
)

$rgs = Get-AzResourceGroup
$rgTags = @()

foreach ($rg in $rgs){

    $tags = Get-AzTag -ResourceId $rg.ResourceId
    if ($tags) {
        if ($tags.Properties.TagsProperty.owner){$owner=$tags.Properties.TagsProperty.owner}else{$owner="None"}
        if ($tags.Properties.TagsProperty.approver){$approver=$tags.Properties.TagsProperty.approver}else{$approver="None"}
        if ($tags.Properties.TagsProperty.endDate){$endDate=$tags.Properties.TagsProperty.endDate}else{$endDate="None"}
        $rgTags += New-Object psobject -Property @{
            "RgName"   = $rg.ResourceGroupName
            "Owner"    = $owner
            "Approver" = $approver
            "EndDate"  = $endDate
        }
    }else{
    $rgTags += New-Object psobject -Property @{
        "RgName"   = $rg.ResourceGroupName
        "Owner"    = "None"
        "Approver" = "None"
        "EndDate"  = "None"
    
    }  
}
}

if ($arg1 -eq "CSV"){

}else{
    $rgTags | Select-Object -Property RgName, Owner, Approver, EndDate
}
