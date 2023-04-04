# Created by: Nick Alderete
## SOURCES ##
# https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adorganizationalunit?view=windowsserver2022-ps
# https://petri.com/creating-active-directory-ous-powershell/
# https://www.server-world.info/en/note?os=Windows_Server_2019&p=active_directory&f=9



# Prompt the user for the name of the new forest and domain
$forestName = Read-Host "Enter the name of the new forest"
$domainName = Read-Host "Enter the name of the new domain"

# Create the new forest using the Install-ADDSForest cmdlet
Install-ADDSForest -DomainName $domainName -DomainNetbiosName ($domainName.Split('.')[0]) -ForestMode WinThreshold -DomainMode WinThreshold -ForestName $forestName
