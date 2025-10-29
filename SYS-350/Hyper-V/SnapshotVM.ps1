#Take an inputted VM name and start the VM in Hyper-V
#System must have the Hyper-V management module installed

$VM = Read-Host -Prompt "What VM would you like to snapshot?"
$SnapName = Read-Host -Prompt "What would you like to name the new shapshot?"

#Check if the Hyper-V module exists and attempt to install if it does not
if (-not (Get-Module -Name "hyper-v" -ListAvailable)){
  Write-Host "Hyper-V module not installed..."
  Write-Host "Attenpting to install module..."
  Get-Command -Module hyper-v | Out-GridView
  if (Get-Module -Name "hyper-v" -ListAvailable){
    Write-Host "Hyper-V module installed!"
  }
  else {
    Write-Host "Error installing Hyper-V module"
  }
}
else{
  Write-Host "Starting task!"
}

#Start a VM with name passed from command
if (Get-VM | where {$_.Name -eq $VM}){
  Checkpoint-VM -Name $VM -SnapshotName $SnapName
  if (Get-VmSnapshot | where {$_.Name -eq $SnapName}){
    Write-Host "Snapshotted $VM successfully!"
  }
  else{
    Write-Host "Failed to snapshot #VM ..."
  }
}
else{
  Write-Host "VM Not found..."
}
