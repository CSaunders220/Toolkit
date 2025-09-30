. (Join-Path $PSScriptRoot ChamplainClassesCarverFunction.ps1)

$table = daysTranslator(gatherClasses)

$table | Where-Object {$_.Instructor -eq "Furkan Paligu"}

$table | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.Days -contains "Monday") } |
Sort-Object "Time Start" |
Select-Object "Time Start", "Time End", "Class Code"

$ITSInstructors = $table | Where-Object { ($_."Class Code" -ilike "SYS*") -or `
                                          ($_."Class Code" -ilike "NET*") -or `
                                          ($_."Class Code" -ilike "SEC*") -or `
                                          ($_."Class Code" -ilike "FOR*") -or `
                                          ($_."Class Code" -ilike "CSI*") -or `
                                          ($_."Class Code" -ilike "DAT*") } `
                        | Sort-Object "Instructor" `
                        | Select-Object "Instructor" -Unique
#$ITSInstructors

$table | where { $_.Instructor -in $ITSInstructors.Instructor} `
       | Group-Object "Instructor" | Select-Object Count,Name | Sort-Object Count -Descending
           