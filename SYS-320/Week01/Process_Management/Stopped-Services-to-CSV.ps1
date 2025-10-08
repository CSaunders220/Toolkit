# Get all stopped services, list them alphabetically, and save it to a CSV
cd $PSScriptRoot

$filepath = "$PSSCriptRoot\Services.csv"
Get-Process | Where-Object {$_.Status -eq "Stopped"} | Sort-Object Name| Export-Csv -Path $filepath
Get-ChildItem -Recurse -File | Where-Object {$_.Name -like "*.csv"}