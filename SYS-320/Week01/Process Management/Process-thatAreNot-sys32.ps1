# Get and list every process that does not contain "system32"
(Get-Process | Where-Object { $_.Name -inotlike "system32"} | Sort-Object Name)