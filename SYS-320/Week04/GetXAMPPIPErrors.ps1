$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String '404'

$regex = [regex] "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\ "

$ipsUnorganized = $regex.matches($notfounds)

$ips = @()
    for($i=0; $i -lt $ipsUnorganized.count; $i++){
        $ips += [PSCustomObject]@{ "IP" = $ipsUnorganized[$i].value}
    }

$ips | Where-Object {$_.IP -ilike "10.*"}