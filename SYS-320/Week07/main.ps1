. (Join-Path $PSScriptRoot email.ps1)
. (Join-Path $PSScriptRoot scheduler.ps1)
. (Join-Path $PSScriptRoot configuration.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

$configuration = readConfiguration
$time = Get-Content ./configuration.txt
$Failed = atRiskUsers
sendAlertEmail ($Failed | Format-Table | Out-String)
ChooseTimeToRun($time[1])