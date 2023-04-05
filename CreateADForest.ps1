# Created by: Nick Alderete, 03APR2023
## SOURCES ##
# https://learn.microsoft.com/en-us/powershell/module/activedirectory/set-adforest?view=windowsserver2022-ps
# https://www.trustedsec.com/blog/active-directory-for-script-kiddies/
# https://rdr-it.com/en/create-an-active-directory-environment-in-powershell/
# https://devblogs.microsoft.com/scripting/use-powershell-to-deploy-a-new-active-directory-forest/



# Prompt the user for the name of the new forest and domain
$forestName = Read-Host "Enter the name of the new forest"
$domainName = Read-Host "Enter the name of the new domain"

# Create the new forest using the Install-ADDSForest cmdlet
Install-ADDSForest -DomainName $domainName -DomainNetbiosName ($domainName.Split('.')[0]) -ForestMode WinThreshold -DomainMode WinThreshold -ForestName $forestName
