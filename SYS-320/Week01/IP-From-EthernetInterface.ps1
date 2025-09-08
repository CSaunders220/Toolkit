#Get IPv4 Address from Eth0 Interface
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet" }).IPAddress
