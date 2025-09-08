#Show all classes in the WinLibrary that start with Net
(Get-WmiObject -List | Where-Object {$_.Name -ilike "Win32_Net*" })