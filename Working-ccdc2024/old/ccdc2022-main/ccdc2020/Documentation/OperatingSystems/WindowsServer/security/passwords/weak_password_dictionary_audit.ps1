# Install DSInternals
Install-Module -Name DSInternals
Import-Module DSInternals
Get-Command -Module DSInternals

# These variables need to be modified depending on the system
$DictFile = "C:\weakpasswords.txt"
$DC = $(hostname)
$Domain = "DC=test,DC=net"

# Get a password quality report using dictionary of weak passwords
Get-ADReplAccount -all -namingcontext $Domain -server $DC | 
Test-PasswordQuality -WeakPasswordsFile $Dictfile -IncludeDisabledAccounts

# If you are comparing with a file that already has weak passwords hashed, replace the -WeakPasswordsFile flag with -WeakPasswordsHashesFile
# For a comprehensive weak password hashes file: haveibeenpwned.com/Passwords