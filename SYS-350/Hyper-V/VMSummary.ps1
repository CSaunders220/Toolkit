$vms = Get-VM | where {$_.Name -ilike "*"} | Get-VMNetworkAdapter
$vms