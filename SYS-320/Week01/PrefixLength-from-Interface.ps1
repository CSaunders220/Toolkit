#Get IPv4 PrefixLength from Ethernet Interface
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet" }).PrefixLength