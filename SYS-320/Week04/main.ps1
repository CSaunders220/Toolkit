. (Join-Path $PSScriptRoot CustomApacheTableFormatFunction.ps1)

clear

$tableRecords = ApacheLogs
$tableRecords | Format-Table -Autosize -Wrap