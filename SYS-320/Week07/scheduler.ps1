function ChooseTimeToRun($Time){
    Write-Host "The time is: " | Write-Host $Time
    $parsedTime = [DateTime]$Time
    
    $scheduledTasks = Get-ScheduledTask | Where-Object {$_.TaskName -ilike "myTask"}

    if($scheduledTasks -ne $null){
        Write-Host "Task already exists" | Out-String
        DisableAutoRun
    }

    Write-Host "Creating task..." | Out-String

    $action = New-ScheduledTaskAction -Execute "powershell.exe" `
              -argument "-File `"C:\Users\chris.saunders-loc\Toolkit\SYS-320\Week07\main.ps1`""
    
    $trigger = New-ScheduledTaskTrigger -Daily -At $parsedTime
    $principal = New-ScheduledTaskPrincipal -UserId 'chris.saunders-loc' -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
    $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings

    Register-ScheduledTask 'myTask' -InputObject $task

    Get-ScheduledTask | Where-Object {$_.TaskName -ilike "myTask"}
}

function DisableAutoRun(){

    $scheduledTasks = Get-ScheduledTask | Where-Object {$_.TaskName -ilike "myTask"}

    if($scheduledTasks -ne $null){
        Write-Host "Unregistering Task" | Out-String
        Unregister-ScheduledTask -TaskName 'myTask' -Confirm:$false
    }
    else{
        Write-Host "The task is not registered" | Out-String
    }
}