# Sierra Maldonado
# Auto Populate Users
#https://social.technet.microsoft.com/Forums/ie/en-US/50bfd4e1-b856-490b-8dba-c4219e0f1b0f/newaduser-the-server-is-unwilling-to-process-the-request?forum=ITCG
# 03Apir23

#Installs tools
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory

#Finds CSV file
$ADUser = Import-Csv "C:\Users\Administrator\Documents\CP.csv"

# For each, reads each line as a new user
Foreach ($User in $ADUser) {
    New-ADUser `
        -Name "$($user.firstname)  $($user.lastname)" `
        -Givenname $user.firstname `
        -Surname $user.lastname `
        -Enabled $true `
        -Path 'OU=$($user.OU),DC=cleanpower,DC=com' `
        -Title $user.jobtitle `
        -Email $user.email `
        -AccountPassword (ConvertTo-SecureString $user.password -AsPlaintext -Force)
}
echo "New Users Added"