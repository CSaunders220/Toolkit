
function configurationMenu {
    Write-Host "================ Main Menu ================"
    Write-Host "[1] Show Configuration"
    Write-Host "[2] Change Configuration"
    Write-Host "[0] Exit the Program"
    Write-Host "==========================================="
}

function readConfiguration {
    $confs = @()
    $confs = Get-Content ./configuration.txt
    $confTable = [PSCustomObject]@{
        Days = $confs[0]
        Time = $confs[1]
    }
    $confTable | Format-Table -Autosize
}

function changeConfiguration {
    Write-Host ""
    $newDays = Read-host "Enter the amount of days worth of logs that will be obtained"
    Write-Host ""
    $newTime = Read-host "Enter the daily execution time for the script eg. 1:20 AM"
    $timeFormat = "h:mm tt"

    if ($newDays -as [int] -and $newDays -ne $null){
        if ($newTime -as [DateTime] -and $newTime -ne $null){
            Set-Content -Path "./configuration.txt" -Value $newDays
            Add-Content -Path "./configuration.txt" -Value $newTime
            Write-Host ""
            Write-Host "Changed configuration successfully!"
        }else{
            Write-Host "Time inputted is not an acceptable input (H:MM TT) or was empty!"
            return
        }
    }else{
        Write-Host "Days value inputted was not an acceptable input (INT) or was empty!"
        return
    }

}

do {
    configurationMenu
    $choice = Read-host "Enter your selection (0 to quit)"
    if ($choice -eq '1'){
        readConfiguration
        Write-Host "Press Enter to continue..."
        Read-Host
    }
    elseif ($choice -eq '2'){
        changeConfiguration
        Start-Sleep -Seconds 3
    }
    elseif($choice -eq '0'){
        Write-Host "Goodbye!"
    }
    else{
        Write-Host "Invalid selection! Try again."
        Start-Sleep -Seconds 2
    }
} until ($choice -eq '0')
