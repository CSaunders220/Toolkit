#Function to get computer startup and shutdown events

function getSystemPowerEvents($days){
    $systemEvents = (Get-EventLog System -After (Get-Date).AddDays(-($days)) | Where {6006,6005 -contains $_.EventID})

    $systemEventsTable = @()
    for($i=0; $i -lt $systemEvents.count; $i++){
    
    $event = ""
    if($systemEvents[$i].EventId -eq 6006) {$event="shutdown"}
    elseif($systemEvents[$i].EventId -eq 6005) {$event="startup"}

    $systemEventsTable += [PSCustomObject]@{
        "Time"   = $loginouts[$i].TimeGenerated
        "ID"     = $systemEvents[$i].EventID
        "Event"  = $event
        "User"   = "System"
        }
    }
    return $systemEventsTable
}

getSystemPowerEvents -days 10
