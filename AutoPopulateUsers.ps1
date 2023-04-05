# Sierra Maldonado
# Auto Populate Users
#https://social.technet.microsoft.com/Forums/ie/en-US/50bfd4e1-b856-490b-8dba-c4219e0f1b0f/newaduser-the-server-is-unwilling-to-process-the-request?forum=ITCG
# 03Apir23

Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory

$ADUser = Import-Csv "C:\Users\Administrator\Documents\CP.csv"
$password = 1234


Foreach ($User in $ADUser) {
    New-ADUser `
        -Name "$($user.firstname)  $($user.lastname)" `
        -Givenname $user.firstname `
        -Surname $user.lastname `
        -Enabled $true `
        -Path 'OU=$($user.OU),DC=cleanpower,DC=com' `
        -Title $user.jobtitle `
        -Email $user.email `
        -AccountPassword (ConvertTo-SecureString $password -AsPlaintext -Force)
}
#end