function sendAlertEmail($body){

    $From = "christopher.saunders@mymail.champlain.edu"
    $To = "christopher.saunders@mymail.champlain.edu"
    $Subject = "SHENANIGANS DETECTED"

    $Password = "yqgd booy xiut lumt" | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
    Send-Mailmessage -From $From -To $To -Subject $Subject -Body $body -SmtpServer "smtp.gmail.com" `
    -port 587 -UseSsl -Credential $Credential

}