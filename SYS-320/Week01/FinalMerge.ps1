. (Join-Path $PSScriptRoot SystemPowerFunction.ps1)
. (Join-Path $PSScriptRoot UserLoginEventsFunction.ps1)

clear

$days = Read-Host -Prompt "How many days worth of logs do you wish to see?: "

$loginoutsTable = getUserEvents -days $days
$loginoutsTable

$systemEventTable = getSystemPowerEvents -days $days
$systemEventTable