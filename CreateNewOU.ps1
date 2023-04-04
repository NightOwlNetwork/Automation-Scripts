# Created by: Nick Alderete
## SOURCES ##
# https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adorganizationalunit?view=windowsserver2022-ps
# https://petri.com/creating-active-directory-ous-powershell/
# https://www.server-world.info/en/note?os=Windows_Server_2019&p=active_directory&f=9


# Prompt the user for the OU name
$ouName = Read-Host "Enter the name for the new OU"

# Prompt the user for the domain name
$domain = Read-Host "Enter the domain for the new OU"

# Create the new OU
New-ADOrganizationalUnit -Name $ouName -Path "DC=$domain,DC=com"
