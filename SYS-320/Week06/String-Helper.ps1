<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>


<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}

<# ******************************************************
   Functions: Check password
   Input:   1) A password as Secure String
   Output:  1) True or False, whether it meeds requirements
********************************************************* #>

function checkPassword($passwd){

   $minLength = 6

   # Password conversion modeled from presentation material
   $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwd)
   $plainpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

   if ($plainpassword.Length -gt $minLength) {
        if (($plainpassword -cmatch '[A-Z]') -or ($plainpassword -cmatch '[a-z]')){
            if ($plainpassword -cmatch '[0-9]'){
                if ($plainpassword -cmatch '[!@#$%^&*()_=+\[{\]};:<>|./?-]'){
                return $true
                }else{
                  return $false
                }
            }else{
               return $false
            }
        }
        else{
            return $false
        }
    }
    else{
        return $false
    }
}