#Take an inputted VM name and change the virtual switch of the VM
#System must have the Hyper-V management module installed

$VM = Read-Host -Prompt "What VM would you like to change the networking on?"
$Switch = Read-Host -Prompt "What switch would you like to switch to?"

#Check if the Hyper-V module exists and attempt to install if it does not
if (-not (Get-Module -Name "hyper-v" -ListAvailable)){
  Write-Host "Hyper-V module not installed..."
  Write-Host "Attenpting to install module..."
  Get-Command -Module hyper-v | Out-GridView
  if (Get-Module -Name "hyper-v" -ListAvailable){
    Write-Host "Hyper-V module installed!"
  }
  else {
    Write-Host "Error installing Hyper-V module" -ForegroundColor Red -BackgroundColor Black
  }
}
else{
  Write-Host "Starting task!"
}

#Change networking of a VM with name passed from command to inputted switch
if (Get-VM | where {$_.Name -eq $VM}){
  if (Get-VMSwitch | where {$_.Name -eq $Switch}){
    Connect-VMNetworkAdapter -VMName $VM -SwitchName $Switch
  }
  else{
    Write-Host "Virtual switch not found..." -ForegroundColor Red -BackgroundColor Black
  }
}
else{
  Write-Host "VM Not found..." -ForegroundColor Red -BackgroundColor Black
}
