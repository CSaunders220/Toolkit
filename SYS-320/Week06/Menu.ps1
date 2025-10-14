. (Join-Path $PSScriptRoot Chrome-to-Champlain.ps1)
. (Join-Path $PSScriptRoot CustomApacheTableFormatFunction.ps1)
. (Join-Path $PSScriptRoot main_1.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)
Clear-Host

function showMenu {
    Clear-Host
    Write-Host "================ Main Menu ================"
    Write-Host "[1] Display Apache Logs"
    Write-Host "[2] Display Failed Logons"
    Write-Host "[3] Display At Risk Users"
    Write-Host "[4] Start Chrome at Champlain.edu"
    Write-Host "[5] Exit the Program"
    Write-Host "==========================================="
}

do {
    showMenu
    $choice = Read-host "Enter your selection (1-4 or 5 to quit)"

    switch ($choice) {
        '1' {
            $tableRecords = ApacheLogs
            $tableRecords | Format-Table -Autosize -Wrap
        }
        '2' {
            $failedLogs = getFailedLogins 10
            $failedLogs | Format-Table -Autosize -Wrap
        }
        '3' { 
            $riskyUsers = 
        }
        '4' { 
            openChrome
        }
        '5' {
            Write-Host "Goodbye!"
            break
        }
        default {
            Write-Host "Invalid selection. Please try again or enter 5 to quit."
            Start-Sleep -Seconds 2
        }
    }
} until ($choice -eq '5')