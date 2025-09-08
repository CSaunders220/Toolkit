cd $PSScriptRoot
$files=Get-ChildItem

$folderpath = "$PSScriptRoot/outfolder/"
$filepath = "$folderpath/out.csv"

$files | Where-Object {$_.Extension -eq ".ps1"} | 
Export-Csv -Path $filepath