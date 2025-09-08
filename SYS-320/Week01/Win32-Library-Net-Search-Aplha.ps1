#Show all classes in the WinLibrary that start with Net AND sort aplhabetically
(Get-WmiObject -List | Where-Object {$_.Name -ilike "Win32_Net*" } | Sort-Object Name)