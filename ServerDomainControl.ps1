#Geneva Knott 
# Install Domain Services
# https://blog.netwrix.com/2018/06/07/how-to-create-new-active-directory-users-with-powershell/
# 3 April 2023

# Install the Active Directory Domain Services role

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote the server to a Domain Controller

Install-ADDSForest `
    -DomainName "cleanpower.com" `
    -DomainNetbiosName "cleanpower" `
    -ForestMode "cleanpower.com" `
    -DomainMode "cleanpower.com" `
    -InstallDns:$true `
    -NoRebootOnCompletion:$false `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL"

# Restart the server to complete the installation

Restart-Computer
