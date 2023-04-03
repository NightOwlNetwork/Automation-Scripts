# Sierra Maldonado
# Auto Populate Users
#https://social.technet.microsoft.com/Forums/ie/en-US/50bfd4e1-b856-490b-8dba-c4219e0f1b0f/newaduser-the-server-is-unwilling-to-process-the-request?forum=ITCG
# 03Apir23

Param (
    [parameter(mandatory=$true)]
    [string]$UserPassword
)

# Filepath
$Filepath = "C:\Users\Administrator\Documents\Clean-Power.csv"

$pswrd = ConvertTo-SecureString $UserPassword -AsPlainText -Force
$users = Import-CSV $Filepath
foreach ($user in $users) {
    $props = @{
        Name = $User.Username + '\' + $User.LastName + $User.FirstName
        DisplayName = $User.LastName + ' ' + $User.FirstName
        EmailAddress = $User.Username + '@cleanpower.com'
        Surname = $User.LastName
        GivenName = $User.FirstName
        AccountPassword = $pswrd
        Path = 'OU=' + $User.OU + ',DC=cleanpower,DC=com' # OU path based on CSV file
        JobTitle = $User.JobTitle # add JobTitle attribute
    }
    New-ADUser @props -PassThru
}
#end