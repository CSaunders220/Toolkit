#Take an inputted VM target and new VM information to make a linked clone
#System must have the Hyper-V management module installed

$VM = Read-Host -Prompt "What VM would you like to create a linked clone of?"
$LinkedName = Read-Host -Prompt "What would you like to name the new VM?"
$LinkedSwitch = Read-Host -Prompt "What Switch would you like to assign to the clone?"

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

$Storage = "V:\ProgramData\Microsoft\Windows\Hyper-V" + "\" + $LinkedName
$ParentVMPath = "V:\Users\Public\Documents\Hyper-V\Virtual Hard Disks" + "\" + $VM + ".vhdx"
$LinkedVMPath = "V:\Users\Public\Documents\Hyper-V\Virtual Hard Disks" + "\" + $LinkedName + ".vhdx"

if (Get-VM | where {$_.Name -eq $VM}){
  if (Get-VMSwitch | where {$_.Name -eq $LinkedSwitch}){
    if (Test-Path -Path $ParentVMPath) {
      Write-Host "Parent virtualdisk exists, continuing!"
      New-VHD -Path $LinkedVMPath -ParentPath $ParentVMPath -Differencing
    }else{
    Write-Host "Parent path not found..." -ForegroundColor Red -BackgroundColor Black
    }
  New-VM -Name $LinkedName -Switch $LinkedSwitch -Path $Storage -VHDPath $LinkedVMPath -Generation 2 -MemoryStartupBytes 2GB
  }else{
    Write-Host "Virtual switch not found..." -ForegroundColor Red -BackgroundColor Black
  }
}else{
  Write-Host "Parent VM not found..." -ForegroundColor Red -BackgroundColor Black
}

if (Get-VM | where {$_.Name -eq $LinkedName}){
  Write-Host "Linked clone created successfully!"
}