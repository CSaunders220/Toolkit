#Take an inputted VM name and start the VM in Hyper-V
#System must have the Hyper-V management module installed

#Check if the Hyper-V module exists and attempt to install if it does not
if (-not (Get-Module -Name "hyper-v" -ListAvailable)){
  Write-Host "Hyper-V module not installed..."
  Write-Host "Attenpting to install module..."
  Get-Command -Module hyper-v | Out-GridView
  if (Get-Module -Name "hyper-v" -ListAvailable){
    Write-Host "Hyper-V module installed!"
  else {
    Write-Host "Error installing Hyper-V module"
  }
else{
  Write-Host "Hyper-V module already installed..."
}

#Start a VM with name passed from command
if (Get-VM | where {$_.Name -eq $1}){
  Start-VM -Name $1
  if (Get-VM | where {$_.Name -eq $1} | where {$_.State -eq 'Running'}){
    Write-Host "Started VM $1 successfully!"
  }
  else{
    Write-Host "VM $1 failed to start..."
  }
}
else{
  Write-Host "VM Not found..."
}
