#Check if chrome is running and if not, start chrome at the champlain.edu website
function openChrome{
    $chrome = (Get-Process | Where-Object {$_.Name -ilike "Chrome"})

    if ($null -eq $chrome) {
        Start-Process "chrome.exe" "https://www.champlain.edu/"
        Write-Host "Chrome has started at the Champlain website"
    }
    else {
        Stop-Process -name chrome
        Write-Host "Chrome was running and has been stopped"
    }
}