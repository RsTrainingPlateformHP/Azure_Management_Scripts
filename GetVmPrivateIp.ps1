$vms = get-azvm
$nics = get-aznetworkinterface | where VirtualMachine -NE $null #skip Nics with no VM

foreach($nic in $nics)
{
    $vm = $vms | where-object -Property Id -EQ $nic.VirtualMachine.id
    $prv =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
    if ($vm.Name -NE $null) {
        Write-Output "$($vm.Name) : $prv"
    }
}