# Sierra Maldonado
# Auto Populate Users
#https://social.technet.microsoft.com/Forums/ie/en-US/50bfd4e1-b856-490b-8dba-c4219e0f1b0f/newaduser-the-server-is-unwilling-to-process-the-request?forum=ITCG
# 03Apir23

#Installs Tools
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory

#Finds CSV File
$ADUser = Import-Csv "C:\Users\Administrator\Documents\CP.csv"

foreach ($User in $ADUser) {
    # Check if user already exists
    $existingUser = Get-ADUser -Filter "GivenName -eq '$($user.firstname)' -and Surname -eq '$($user.lastname)'" -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Warning "User $($user.firstname) $($user.lastname) already exists in Active Directory."
        continue
    }

    # Create new user account
    New-ADUser `
        -Name "$($user.firstname) $($user.lastname)" `
        -GivenName $user.firstname `
        -Surname $user.lastname `
        -Enabled $true `
        -Path "OU=$($user.OU),DC=cleanpower,DC=com" `
        -Title $user.jobtitle `
        -Email $user.email `
        -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force)
}
