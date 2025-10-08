# Get and list every process that starts with the letter "c"
(Get-Process | Where-Object { $_.Name -ilike "C*"} | Sort-Object Name)