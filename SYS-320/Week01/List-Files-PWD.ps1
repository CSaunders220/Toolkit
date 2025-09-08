cd $PSScriptRoot

$files = Get-ChildItem
for ($j=0; $j -le $files.Count-1; $j++){
    if ($files[$j].Name -like "*.ps1"){
        Write-Host $files[$j].Name
    }
}