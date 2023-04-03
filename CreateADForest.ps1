# Created by: Nick Alderete, 03APR2023
## SOURCES ##
# https://learn.microsoft.com/en-us/powershell/module/activedirectory/set-adforest?view=windowsserver2022-ps
# https://www.trustedsec.com/blog/active-directory-for-script-kiddies/
# https://rdr-it.com/en/create-an-active-directory-environment-in-powershell/
# https://devblogs.microsoft.com/scripting/use-powershell-to-deploy-a-new-active-directory-forest/



# Prompt user for forest and domain name
$forestName = Read-Host "Enter the forest name"
$domainName = Read-Host "Enter the domain name"

# Ask for confirmation
$confirmation = Read-Host "Are you sure you want to create a new AD forest for $forestName.$domainName? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Operation cancelled"
    exit
}

# Install AD DS role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Promote server to domain controller
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName "$domainName" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -Confirm:$false

# Echo back completion message
Write-Host "AD Forest creation and server promotion completed."