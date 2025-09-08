# Get DHCP server IP
(Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | 
Select -Property DHCPServer | Format-Table -HideTableHeaders)