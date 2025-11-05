#Take an inputted VM name and stop the VM in Hyper-V
#System must have the Hyper-V management module installed

$VM = Read-Host -Prompt "What VM would you like to shutdown?"

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
  Write-Host "Hyper-V module already installed..."
}

#Stop a VM with name passed from command
if (Get-VM | where {$_.Name -eq $VM}){
  Stop-VM -Name $VM
  if (Get-VM | where {$_.Name -eq $VM} | where {$_.State -eq 'Off'}){
    Write-Host "Shutdown VM $VM successfully!"
  }
  else{
    Write-Host "VM $VM failed to stop..." -ForegroundColor Red -BackgroundColor Black
  }
}
else{
  Write-Host "VM Not found..." -ForegroundColor Red -BackgroundColor Black
}
