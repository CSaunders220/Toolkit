$webpage1 = "/index.html"
$browser1 = "Chrome"
$status1 = "200"

function getWebTrafficLogs($webpage, $browser, $status){
    
    $logs = Get-Content C:\xampp\apache\logs\access.log
    
    $FilteredLogs = @()
    $FilteredLogs += $logs | Where-Object {$_ -contains "$browser"} |
     Where-Object {$_ -contains "$status"} |
     Where-Object {$_ -contains "$webpage"}

    $FilteredLogs | ForEach-Object {
        $IP = ($_ -split "\s")[0]
        $matchestable = @()
        $matchestable += $IP
    }
  return $matchestable
}

getWebTrafficLogs($webpage1, $browser1, $status1)