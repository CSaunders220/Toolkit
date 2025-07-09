# AD User Creation Script with Group Assignment and Expiration
# Requires Active Directory PowerShell module

# Import the Active Directory module
Import-Module ActiveDirectory

# Configuration Variables
$TargetOU = "OU=TempUsers,DC=yourdomain,DC=com"  # Change to your target OU
$GroupName = "TempUserGroup"  # Change to your target group
$DefaultPassword = "TempPass123!"  # Change to your default password policy compliant password
$ExpirationDays = 90  # Number of days until account expires

# Function to create AD user with expiration and group membership
function New-ADUserWithExpiration {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FirstName,
        
        [Parameter(Mandatory=$true)]
        [string]$LastName,
        
        [Parameter(Mandatory=$true)]
        [string]$Username,
        
        [Parameter(Mandatory=$false)]
        [int]$ExpirationDays = 90,
        
        [Parameter(Mandatory=$false)]
        [string]$CustomOU = $TargetOU,
        
        [Parameter(Mandatory=$false)]
        [string]$CustomGroup = $GroupName
    )
    
    try {
        # Calculate expiration date
        $ExpirationDate = (Get-Date).AddDays($ExpirationDays)
        
        # Create secure password
        $SecurePassword = ConvertTo-SecureString $DefaultPassword -AsPlainText -Force
        
        # Check if user already exists
        if (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue) {
            Write-Warning "User '$Username' already exists. Skipping creation."
            return $false
        }
        
        # Create the user
        $UserParams = @{
            Name = "$FirstName $LastName"
            GivenName = $FirstName
            Surname = $LastName
            SamAccountName = $Username
            UserPrincipalName = "$Username@$((Get-ADDomain).DNSRoot)"
            Path = $CustomOU
            AccountPassword = $SecurePassword
            Enabled = $true
            ChangePasswordAtLogon = $false
            AccountExpirationDate = $ExpirationDate
            PasswordNeverExpires = $true
        }
        
        # Add optional parameters if provided
        if ($Email) { $UserParams.EmailAddress = $Email }
        if ($Department) { $UserParams.Department = $Department }
        
        # Create the user
        New-ADUser @UserParams
        Write-Host "✓ User '$Username' created successfully" -ForegroundColor Green
        Write-Host "  - Full Name: $FirstName $LastName" -ForegroundColor Gray
        Write-Host "  - OU: $CustomOU" -ForegroundColor Gray
        Write-Host "  - Expires: $($ExpirationDate.ToString('MM/dd/yyyy'))" -ForegroundColor Gray
        
        # Add user to group
        if ($CustomGroup) {
            try {
                Add-ADGroupMember -Identity $CustomGroup -Members $Username
                Write-Host "  - Added to group: $CustomGroup" -ForegroundColor Green
            }
            catch {
                Write-Warning "Failed to add user '$Username' to group '$CustomGroup': $($_.Exception.Message)"
            }
        }
        
        return $true
    }
    catch {
        Write-Error "Failed to create user '$Username': $($_.Exception.Message)"
        return $false
    }
}

# Function to create multiple users from CSV
function New-ADUsersFromCSV {
    param(
        [Parameter(Mandatory=$true)]
        [string]$CSVPath
    )
    
    if (-not (Test-Path $CSVPath)) {
        Write-Error "CSV file not found: $CSVPath"
        return
    }
    
    $Users = Import-Csv -Path $CSVPath
    $SuccessCount = 0
    $FailureCount = 0
    
    foreach ($User in $Users) {
        $Result = New-ADUserWithExpiration -FirstName $User.FirstName -LastName $User.LastName -Username $User.Username -Email $User.Email -Department $User.Department -ExpirationDays $User.ExpirationDays
        
        if ($Result) {
            $SuccessCount++
        } else {
            $FailureCount++
        }
    }
    
    Write-Host "`nSummary:" -ForegroundColor Yellow
    Write-Host "  - Successfully created: $SuccessCount users" -ForegroundColor Green
    Write-Host "  - Failed: $FailureCount users" -ForegroundColor Red
}

# Function to validate prerequisites
function Test-Prerequisites {
    # Check if AD module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "Active Directory PowerShell module is not installed."
        return $false
    }
    
    # Check if target OU exists
    try {
        Get-ADOrganizationalUnit -Identity $TargetOU -ErrorAction Stop | Out-Null
        Write-Host "✓ Target OU exists: $TargetOU" -ForegroundColor Green
    }
    catch {
        Write-Error "Target OU does not exist: $TargetOU"
        return $false
    }
    
    # Check if target group exists
    try {
        Get-ADGroup -Identity $GroupName -ErrorAction Stop | Out-Null
        Write-Host "✓ Target group exists: $GroupName" -ForegroundColor Green
    }
    catch {
        Write-Error "Target group does not exist: $GroupName"
        return $false
    }
    
    return $true
}

# Main execution
Write-Host "AD User Creation Script" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

# Validate prerequisites
if (-not (Test-Prerequisites)) {
    Write-Host "Prerequisites check failed. Please fix the issues above." -ForegroundColor Red
    exit 1
}

# Example usage - Create single user
Write-Host "`nExample: Creating single user..." -ForegroundColor Yellow
# Uncomment and modify the line below to create a single user
# New-ADUserWithExpiration -FirstName "John" -LastName "Doe" -Username "jdoe" -Email "john.doe@company.com" -Department "IT"

# Example usage - Create multiple users from CSV
Write-Host "`nTo create multiple users from CSV, use:" -ForegroundColor Yellow
Write-Host "New-ADUsersFromCSV -CSVPath 'C:\path\to\users.csv'" -ForegroundColor Gray

Write-Host "`nCSV Format should include columns:" -ForegroundColor Yellow
Write-Host "FirstName,LastName,Username,Email,Department,ExpirationDays" -ForegroundColor Gray
Write-Host "John,Doe,jdoe,john.doe@company.com,IT,90" -ForegroundColor Gray
Write-Host "Jane,Smith,jsmith,jane.smith@company.com,HR,60" -ForegroundColor Gray

Write-Host "`nScript loaded successfully. You can now use:" -ForegroundColor Green
Write-Host "- New-ADUserWithExpiration for single users" -ForegroundColor Green
Write-Host "- New-ADUsersFromCSV for bulk creation" -ForegroundColor Green
