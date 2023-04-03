# Sierra Maldonado
# Auto Populate Users
#https://social.technet.microsoft.com/Forums/ie/en-US/50bfd4e1-b856-490b-8dba-c4219e0f1b0f/newaduser-the-server-is-unwilling-to-process-the-request?forum=ITCG



Param (
    [parameter(mandatory=$true)]
    [string]$UserPassword
)

# Filepath
$Filepath = "C:\Users\Administrator\Documents\Clean-Power.csv"

# Var
$pswrd = ConvertTo-SecureString $UserPassword -AsPlainText -Force
$users = Import-CSV $Filepath

# Goes to CSV file and locates the Data then runs the NewADUser for each person
foreach ($user in $users) {
    $props = @{
        Name = $User.Username + '\' + $User.LastName + $User.FirstName
        DisplayName = $User.LastName + ' ' + $User.FirstName
        EmailAddress = $User.Username + '@cleanpower.com'
        Surname = $User.LastName
        GivenName = $User.FirstName # Add GivenName property
        AccountPassword = $pswrd
    }
    New-ADUser @props -PassThru
}
