# Create a folder called outfolder if it does not exist

$folderpath="$PSScriptRoot\outfolder"
if (Test-Path -Path $folderpath){
    Write-Host "Folder Already Exists"
}
else{
    New-Item -ItemType Directory -Path $folderpath
}