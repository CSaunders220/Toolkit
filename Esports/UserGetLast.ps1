$TargetUsername = 'jbrown'  
$StartTime = (Get-Date).AddHours(-48)
$LogonTypeDescriptions = @{
    '2'  = 'Interactive'
    '3'  = 'Network'
    '7'  = 'Unlock'
    '10' = 'RemoteInteractive'
    '11' = 'CachedInteractive'
}
$DomainControllers = Get-ADDomainController -Filter *
$LogonEvents = @()
foreach ($DC in $DomainControllers) {
    $FilterHashtable = @{
        LogName   = 'Security'
        ID        = 4624
        StartTime = $StartTime
    }
    $Events = Get-WinEvent -ComputerName $DC.HostName -FilterHashtable $FilterHashtable -ErrorAction SilentlyContinue
    foreach ($Event in $Events) {
        $EventData = [xml]$Event.ToXml()
        $EventUser = $EventData.Event.EventData.Data[5].'#text'
        $LogonTypeCode = $EventData.Event.EventData.Data[8].'#text'
        if ($EventUser -eq $TargetUsername) {
            $LogonEvent = [PSCustomObject]@{
                TimeCreated  = $Event.TimeCreated
                ComputerName = $EventData.Event.EventData.Data[18].'#text'  
                IPAddress    = $EventData.Event.EventData.Data[18].'#text'  
                Username     = $EventUser
                LogonType    = $LogonTypeDescriptions[$LogonTypeCode] 
                DCName       = $DC.HostName
            }
            $LogonEvents += $LogonEvent
        }
    }
}