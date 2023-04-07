# Script: Ops 301 Final Project: Night Owl Network 
# Author: Connie Uribe Chavez
# Date of lates revision: 04 Apr 2023
# Purpose: Renames the Windows Server VM Powershell Scripting
# Reference: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-7.3


# MAIN

# Renames the Windows Server VM
Rename-Computer -NewName "Server044" -DomainCredential
CORP\administrator -Restart
ipconfig /all

#END
