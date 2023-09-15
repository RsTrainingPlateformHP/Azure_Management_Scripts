# =======================================================
# NAME: GetDealloactedVmsLogs.ps1
# AUTHOR: LEGOUPIL, Clement, Entreprise
# DATE: 10/02/2023
# =======================================================
param(
    [string]$args1
)

$LogsReport = @()
$MonthAgoDdate = (Get-Date).AddMonths(-1)
$vms = Get-AzureRmVm | Where-Object { $_.Name -notlike "*training*labs*" }
$counter=0
foreach($vm in $vms)
{
    $counter++
    write-progress -Activity 'Processing Vms' -Status "Processing $($counter) of $($vms.count) - ($($vm.Name))" -CurrentOperation $vm -PercentComplete (($counter / $vms.count)*100)
    
    $logs = Get-AzLog -StartTime $MonthAgoDdate -DetailedOutput -ResourceId $vm.Id -WarningAction 0| Where-Object {$_.Authorization.Action -like 'Microsoft.Compute/virtualMachines/deallocate/action*'}
    if ($logs){
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
    }else{
        write-host $vm.tags
        $LogsReport += New-Object psobject -Property @{
                    "VMName" = $vm.Name
                    "VMId" = $vm.Id
                    "VMSize" = $vm.HardwareProfile.VmSize
                    "OperationName" = "No logs from more than 1 month"
                    "LogTimeStamp" = "30d+"
                }
    }
}


$LogsReport = $LogsReport | Select-Object -Property *, @{Name="Hash";Expression={$_ | Out-String}} | Sort-Object -Property Hash -Unique | Select-Object -Property * -ExcludeProperty Hash
$nowDate = Get-Date -Format "dd-MM-yyyy"
if ($LogsReport){
    if ($args1 -eq "CSV"){
        $LogsReport | Export-Csv "report-$nowDate.csv"
    }else{
        $LogsReport | Select-Object -Property VMName, VMSize, LogTimeStamp, OperationName
    }
}else{
    write-host "No logs to display"
}
