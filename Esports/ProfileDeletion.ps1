# Domain User Profile Removal Script | By: Mike N.
# Use: Removes all Domain User Profiles from the local system - (NOTE: Restart may be completed beforehand to ensure all users are logged out, but is not required to run)

# Array used to define profiles to exclude
$array = @('chris.saunders-adm', 'lukas.muecke-mgr', 'kaiden.slusarz-mgr', 'john.koehler-mgr', 'jackson.evanow-mgr', 'christian.konczal-adm', 'NetworkService', 'LocalService', 'SystemProfile')

# Commands used to retrive all available user profiles on system (*excluding selection above), then delete
Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -notin $array } | Remove-CimInstance -Confirm:$false
