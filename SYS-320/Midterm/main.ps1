# Christopher Saunders midterm scripting assessment for SYS-320

# This line gets the content of the web page hosting the table for the IOC's that will be compared
$webpage = Invoke-WebRequest -Uri "http://10.0.17.25/IOC-1.html"

<# This section of code takes in that web page and breaks it up by tag. This will then
allow me to make a PSCustomObject table for the pattern listed and the description provided #>
Write-Host ("")
Write-Host ("============================================ IOC Table ============================================") -ForegroundColor yellow
$table = $webpage.ParsedHtml
$headers = $table.getElementsByTagName("th") | ForEach-Object {$_.innerText.Trim()}
$patternTable = foreach ($row in $table.getElementsByTagName("tr")){
    $cells = $row.getElementsByTagName("td") | ForEach-Object {$_.innerText.Trim()}
    if ($cells.Count -gt 0) {
        $properties = @{}
        for ($i = 0; $i -lt $headers.Count; $i++){
            $properties[$headers[$i]] = $cells[$i]
        }
        [PSCustomObject]$properties
    }
}
$patternTable | Format-Table -Autosize
Write-Host ("============================================ All Logs ============================================") -ForegroundColor yellow

# The following lines gets the content from the provided log file called "access.log"
$logs = Get-Content C:\Users\chris.saunders-loc\Toolkit\SYS-320\Midterm\access.log
$logTable = @()

<#The following block loops through each log and assigns it to a PSCustomObject based 
on the log content. This will later allow me to compare a specific column with the contents
 of another column. #>
for($i=0; $i -lt $logs.Length; $i++){
    
    $words = $logs[$i].split(" ");

    $logTable += [PSCustomObject]@{
        "IP" = $words[0];
        "Time" = $words[3].Trim('[');
        "Method" = $words[5].Trim('"');
        "Page" = $words[6]
        "Protocol" = $words[7];
        "Response" = $words[8];
        "Referrer" = $words[10];
    }
}

$logTable | Format-Table -Autosize -Wrap

<# The last block of code below loops through the pages or URIs from the log entries and checks if
any of the IOC values from the pattern column are present within the page URI string and if it is
then it will add the log to a seperate custom table and then output it. #>
Write-Host ("============================================ Matching Logs ============================================") -ForegroundColor yellow
$logMatches = @()
$matches = foreach ($log in $logTable){
    foreach ($pattern in $patternTable.Pattern){
        if ($log -match $pattern){
            $logMatches += $log
        }
    }
}

$logMatches | Format-Table -Autosize -Wrap