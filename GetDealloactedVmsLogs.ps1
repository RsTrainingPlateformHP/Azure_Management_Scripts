# =======================================================
# NAME: GetDealloactedVmsLogs.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 10/02/2023
# =======================================================
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$show
)

$LogsReport = @()
$MonthAgoDdate = (Get-Date).AddMonths(-1)
$vms = Get-AzureRmVm
$counter=0
foreach($vm in $vms)
{
    $counter++
    write-progress -Activity 'Processing Vms' -Status "Processing $($counter) of $($vms.count) - ($($vm.Name))" -CurrentOperation $vm -PercentComplete (($counter / $vms.count)*100)
    if ($vm.Name.ToLower() -like "*training*labs*")
    {
        continue
    }else{
    $logs = Get-AzLog -StartTime $MonthAgoDdate -DetailedOutput -ResourceId $vm.Id -WarningAction 0| Where-Object {$_.Authorization.Action -like 'Microsoft.Compute/virtualMachines/deallocate/action*'}
    foreach ($log in $logs)
    {
        $date = $log.EventTimestamp -split " "
        $date = $date[0] -split "/"
        $date = "$($date[1])/$($date[0])/$($date[2])"
        $LogsReport += New-Object psobject -Property @{
            "VMName" = $vm.Name
            "VMId" = $vm.Id
            "VMSize" = $vm.HardwareProfile.VmSize
            "OperationName" = $log.OperationName
            "LogTimeStamp" = $date

        }
    }
    }
    
}

write-host "param " $show

if($show){
    write-host "Yes optional argument"
    $LogsReport
}

$nowDate = Get-Date -Format "dd-MM-yyyy"
$LogsReport | Export-Csv "report-$nowDate.csv"