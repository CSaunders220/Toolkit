#Get Files
$files= Get-ChildItem -Recurse -File

#Sort for files that have .csv and change to .log
$files | Where-Object { $_.Extension -eq ".csv" } |
Rename-Item -NewName { $_.BaseName + ".log" }

#Re-get files
Get-ChildItem -Recurse -File