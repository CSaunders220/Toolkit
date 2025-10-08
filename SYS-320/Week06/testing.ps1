
function checkPassword ($plainpassword){
    if ($plainpassword.Length -gt 6) {
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

$test = checkPassword test11!
Write-Host $test