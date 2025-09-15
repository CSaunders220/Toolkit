# Get login and logoff records and save to a varialbe from the last 14 days AND translate username
$loginouts = Get-EventLog System -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-14)

$loginoutsTable = @()
for($i=0; $i -lt $loginouts.count; $i++){
    
    $event = ""
    if($loginouts[$i].InstanceId -eq 7001) {$event="logon"}
    elseif($loginouts[$i].InstanceId -eq 7002) {$event="logoff"}

    $sid = $loginouts[$i].ReplacementStrings[1]

    $user = (New-Object System.Security.Principal.SecurityIdentifier($sid))
    $user = $user.Translate([System.Security.Principal.NTAccount])

    $loginoutsTable += [PScustomObject]@{
        "Time"   = $loginouts[$i].TimeGenerated
        "ID"     =  $loginouts[$i].InstanceId
        "Event"  = $event
        "User"   = $user.value
    }
}

$loginoutsTable