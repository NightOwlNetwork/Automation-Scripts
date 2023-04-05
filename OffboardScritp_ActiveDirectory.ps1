#Geneva Knott 
# Auto Delete User
# https://blog.netwrix.com/2018/06/07/how-to-create-new-active-directory-users-with-powershell/
# 3 April 2023

# This code can be ran upon termination of an employee. 
Import-Module Active Directory

# Retrieve the user
$SamAccountName = Read-Host "Enter username of user you wish to delete"
Get-ADUser $SamAccountName

# Prompt to delete the user

$DeleteUser = Read-Host "Do you want to delete the user? (Yes/No)"
if ($DeleteUser -eq "Yes") {

    # Delete the user
    
    Remove-ADUser -Identity $SamAccountName -Confirm:$false
    Write-Host "User account $SamAccountName has been deleted."
} else {
    Write-Host "User account $SamAccountName has not been deleted."
}