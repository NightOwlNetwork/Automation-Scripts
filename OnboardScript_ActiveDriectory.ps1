#Geneva Knott 
# Auto New User
# https://blog.netwrix.com/2018/06/07/how-to-create-new-active-directory-users-with-powershell/
# 3 April 2023

Import-Module ActiveDirectory

# Prompt for user details
$Name = Read-Host "Enter the full name of the user"
$GivenName = Read-Host "Enter the user's first name"
$Surname = Read-Host "Enter the user's last name"
$SamAccountName = Read-Host "Enter the user's SamAccountName"
$Email = Read-Host "Enter the user's email address"
$Password = Read-Host "Enter the user's password" -AsSecureString
$Enabled = Read-Host "Enable user account? (True/False)"

# Create the new user
New-ADUser -Name $Name -GivenName $GivenName -Surname $Surname -SamAccountName $SamAccountName -UserPrincipalName "$SamAccountName@$DomainName" -EmailAddress $Email -AccountPassword $Password -Enabled $Enabled
# Retrieve the user
Get-ADUser $SamAccountName