function printMenu{
    Write-Host "--------------------------------------" -ForegroundColor Yellow
    Write-Host "1 - Restore a Checkpoint" -ForegroundColor Yellow
    Write-Host "2 - Create a Full Clone of a VM" -ForegroundColor Yellow
    Write-Host "3 - Edit VM Resources" -ForegroundColor Yellow
    Write-Host "4 - Delete a VM" -ForegroundColor Yellow
    Write-Host "5 - Copy a file to a VM" -ForegroundColor Yellow
    Write-Host "6 - Execute a Command on a VM" -ForegroundColor Yellow
    Write-Host "7 - Start a VM" -ForegroundColor Yellow
    Write-Host "8 - Stop a VM" -ForegroundColor Yellow
    Write-Host "9 - Create a Linked Clone of a VM" -ForegroundColor Yellow
    Write-Host "10 - Summary of All VMs on Server" -ForegroundColor Yellow
    Write-Host "11 - Summary of a Specific VM's Information" -ForegroundColor Yellow
    Write-Host "12 - Snapshot a VM" -ForegroundColor Yellow
    Write-Host "13 - Change the Network Adapter of a VM" -ForegroundColor Yellow
    Write-Host "0 - End Program" -ForegroundColor Yellow
    Write-Host "--------------------------------------" -ForegroundColor Yellow
}

function moduleCheck {
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
}

function startVM {
    $VM = Read-Host -Prompt "What VM would you like to start?"
    if (Get-VM | where {$_.Name -eq $VM}){
      Start-VM -Name $VM
      if (Get-VM | where {$_.Name -eq $VM} | where {$_.State -eq 'Running'}){
        Write-Host "Started VM $VM successfully!"
      }
      else{
        Write-Host "VM $VM failed to start..." -ForegroundColor Red -BackgroundColor Black
      }
    }
    else{
      Write-Host "VM Not found..." -ForegroundColor Red -BackgroundColor Black
    }
}

function stopVM {
    $VM = Read-Host -Prompt "What VM would you like to start?"
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
}

function snapVM {
    $VM = Read-Host -Prompt "What VM would you like to snapshot?"
    $SnapName = Read-Host -Prompt "What would you like to name the new shapshot?"
    if (Get-VM | where {$_.Name -eq $VM}){
      Checkpoint-VM -VMName $VM -SnapshotName $SnapName
      if (Get-VmSnapshot -VMName $VM | where {$_.Name -eq $SnapName}){
        Write-Host "Snapshotted $VM successfully!"
      }
      else{
        Write-Host "Failed to snapshot #VM ..." -ForegroundColor Red -BackgroundColor Black
      }
    }
    else{
      Write-Host "VM Not found..." -ForegroundColor Red -BackgroundColor Black
    }
}

function linkedClone {
    $VM = Read-Host -Prompt "What VM would you like to create a linked clone of?"
    $LinkedName = Read-Host -Prompt "What would you like to name the new VM?"
    $LinkedSwitch = Read-Host -Prompt "What Switch would you like to assign to the clone?"
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
}

function fullClone {
    $VM = Read-Host -Prompt "What VM would you like to create a linked clone of?"
    $CloneName = Read-Host -Prompt "What would you like to name the new VM?"
    $CloneSwitch = Read-Host -Prompt "What Switch would you like to assign to the clone?"
    $Storage = "V:\ProgramData\Microsoft\Windows\Hyper-V" + "\" + $LinkedName
    $ParentVMPath = "V:\Users\Public\Documents\Hyper-V\Virtual Hard Disks" + "\" + $VM + ".vhdx"
    $ClonedPath = "V:\Users\Public\Documents\Hyper-V\Virtual Hard Disks" + "\" + $LinkedName + ".vhdx"

    if (Get-VM | where {$_.Name -eq $VM}){
      if (Get-VMSwitch | where {$_.Name -eq $CloneSwitch}){
        if (Test-Path -Path $ParentVMPath) {
          Write-Host "Parent virtualdisk exists, continuing!"
          New-VHD -Path $ClonedPath -ParentPath $ParentVMPath
        }else{
        Write-Host "Parent path not found..." -ForegroundColor Red -BackgroundColor Black
        }
      New-VM -Name $CloneName -Switch $CloneSwitch -Path $Storage -VHDPath $ClonedPath -Generation 2 -MemoryStartupBytes 2GB
      }else{
        Write-Host "Virtual switch not found..." -ForegroundColor Red -BackgroundColor Black
      }
    }else{
      Write-Host "Parent VM not found..." -ForegroundColor Red -BackgroundColor Black
    }

    if (Get-VM | where {$_.Name -eq $CloneName}){
      Write-Host "Linked clone created successfully!"
    }
}

function vmSummary {
    $vms = Get-VM | where {$_.Name -ilike "*"} | Get-VMNetworkAdapter
    $vms | Format-Table -AutoSize | Out-String
}

function restoreSnap {
    $VM = Read-Host -Prompt "What VM would you like to restore a snap of?"
    Get-VMSnapshot -VMName $VM | Format-table
    $snapName = Read-Host -Prompt "What snap would you like to restore?"
    Restore-VMSnapshot -Name $snapName -VMName $VM
}

function editResources {
    $VM = Read-Host -Prompt "What VM would you like to edit?"
    $CPU = Read-Host -Prompt "How many CPUs would you like to allocate?"
    Stop-VM -Name $VM
    Set-VMProcessor -VMName $VM -Count $CPU
    Start-VM -Name $VM
}

function deleteVM {
    $VM = Read-Host -Prompt "What VM would you like to delete?"
    if (Get-VM | where {$_.Name -eq $VM}){
      $DC = Read-Host -Prompt "Are you sure you wish to delete $VM?"
      if ($DC -eq "y"){
        Remove-VM -Name $VM
      }
      else {
      Write-Host "Failed the double check, exiting..." -ForegroundColor Red -BackgroundColor Black
      }
    }
    else{
      Write-Host "VM Not found..." -ForegroundColor Red -BackgroundColor Black
    }
}

function copyFile {
    $VM = Read-Host -Prompt "What VM would you like to execute commands on?"
    $sourcePath = Read-Host -Prompt "What is the full path of the file you wish to copy to the VM?"
    $targetPath = Read-Host -Prompt "What is the destination path you wish to store the new file on the VM?"
    $s = New-PSSession -VMName $VM -Credential (Get-Credential)
    Copy-Item -ToSession $s -Path $sourcePath -Destination $targetPath -CreateFullPath
    Remove-PSSession $s
}

function execCommand {
    $VM = Read-Host -Prompt "What VM would you like to execute commands on?"
    $Command = Read-Host -Prompt "What command would you like to pass to the VM?"
    $Execution = Invoke-Command -VMName $VM -ScriptBlock {Invoke-Expression -Command $using:Command }
    $Execution
}

function specificSummary {
    Write-Host "Available VMs:" -ForegroundColor Yellow
    $VMNames = Get-VM | where {$_.Name -ilike "*"} | Select-Object VMName
    $VMNames | Out-String | Write-Host -ForegroundColor Yellow
    Write-Host "--------------------------------------" -ForegroundColor Yellow
    $vmSelection = Read-Host -Prompt "What VM would you like to view?"
    Write-Host "--------------------------------------" -ForegroundColor Yellow
    $targetVMInfo = Get-VM | where {$_.VMName -eq $vmSelection}
    $targetVMInfo | Out-String | Format-Table -AutoSize
}

function switchSwitches {
    $VM = Read-Host -Prompt "What VM would you like to change the networking on?"
    $Switch = Read-Host -Prompt "What switch would you like to switch to?"
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
}

moduleCheck

do{
    Write-Host ""
    printMenu
    $Choice = Read-Host -Prompt "What action would you like to take (0-13)?"

    if ($Choice -eq 1) {
        restoreSnap
    }
    elseif ($Choice -eq 2) {
        fullClone
    }
    elseif ($Choice -eq 3) {
        editResources
    }
    elseif ($Choice -eq 4) {
        deleteVM
    }
    elseif ($Choice -eq 5) {
        copyFile
    }
    elseif ($Choice -eq 6) {
        execCommand
    }
    elseif ($Choice -eq 7) {
        startVM
    }
    elseif ($Choice -eq 8) {
        stopVM
    }
    elseif ($Choice -eq 9) {
        linkedClone
    }
    elseif ($Choice -eq 10) {
        vmSummary
    }
    elseif ($Choice -eq 11) {
        specificSummary
    }
    elseif ($Choice -eq 12) {
        snapVM
    }
    elseif ($Choice -eq 13) {
        switchSwitches
    }
    elseif ($Choice -eq 0) {
        Write-Host "Goodbye!"
    }
    else {
        Write-Host "Invalid Input..."
    }
} while ($Choice -ne 0)