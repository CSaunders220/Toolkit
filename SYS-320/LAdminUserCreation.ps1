#Simple user creation script for a local admin user on a windows machine with Powershell
$Password = Read-Host -AsSecureString -Prompt "Enter password"
$FName = Read-Host -Prompt "User's First Name"
$LName = Read-Host -Prompt "User's Last Name"
$FullName = $FName + " " + $LName
$Login = $FName + "." + $LName
New-LocalUser -Name "$" -Password $Password -FullName "$FullName" -Description "Local user account"
Add-LocalGroupMember -Group "Administrators" -Member "$Login"
Restart-Computer -Force
