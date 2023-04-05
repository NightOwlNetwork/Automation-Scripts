# Nick, Sierra, Connie, Geneva
# Start from blank server script

# Set Execution Policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Assigns the Window Server VM a static IPv4 Address 
# Write-Host $adapter.name
Get-NetAdapter -name ethernet | New-NetIPAddress 192.168.1.11 #-DefaultGateway 192.168.1.1 -PrefixLength 24
(Get-NetAdapter -Name ethernet | Get-NetIPAddress).IPv4Address

# Assigns the Window Server VM a static DNS
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 192.168.1.11,127.0.0.11
Get-DnsClientServerAddress

# Renames the Windows Server VM
Rename-Computer -NewName "Server044" -DomainCredential
CORP\administrator -Restart
ipconfig /all


Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Check if the AD-Domain-Services role is already installed
$adRole = Get-WindowsFeature -Name AD-Domain-Services
if ($adRole.Installed -ne "True") {

    # Install the AD-Domain-Services role and management tools
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    
    Write-Output "AD-Domain-Services role and management tools installed successfully."

} else {
    Write-Output "AD-Domain-Services role is already installed."
}
# Promote the server to a Domain Controller

Install-ADDSForest `
    -DomainName "cleanpower.com" `
    -DomainNetbiosName "CLEANPOWER" `
    -ForestMode "Default" `
    -DomainMode "Default" `
    -InstallDns:$true `
    -NoRebootOnCompletion:$false `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL"



# Restart the server to complete the installation
Restart-Computer

# Wait for the computer to come back online
while (-not (Test-Connection -ComputerName localhost -Count 1 -Quiet)) {
    Start-Sleep -Seconds 5
}

# Prompt the user for the name of the new forest and domain
$forestName = Read-Host "Enter the name of the new forest"
$domainName = Read-Host "Enter the name of the new domain"

# Create the new forest using the Install-ADDSForest cmdlet
Install-ADDSForest -DomainName $domainName -DomainNetbiosName ($domainName.Split('.')[0]) -ForestMode WinThreshold -DomainMode WinThreshold -ForestName $forestName


# Prompt the user for the OU name
$ouName = Read-Host "Enter the name for the new OU"

# Create the new OU
New-ADOrganizationalUnit -Name $ouName -Path "DC=$domain,DC=com"

#Installs Tools
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory

#Finds CSV File
$ADUser = Import-Csv "C:\Users\Administrator\Documents\CP.csv"

foreach ($User in $ADUser) {
    # Check if user already exists
    $existingUser = Get-ADUser -Filter "GivenName -eq '$($user.firstname)' -and Surname -eq '$($user.lastname)'" -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Warning "User $($user.firstname) $($user.lastname) already exists in Active Directory."
        continue
    }

    # Create new user account
    New-ADUser `
        -Name "$($user.firstname) $($user.lastname)" `
        -GivenName $user.firstname `
        -Surname $user.lastname `
        -Enabled $true `
        -Path "OU=$($user.OU),DC=cleanpower,DC=com" `
        -Title $user.jobtitle `
        -Email $user.email `
        -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force)

$AccountEnabled = Get-ADUser -Identity $($User.username) -Properties Enabled | Select-Object -ExpandProperty Enabled
    if (!$AccountEnabled) {
        Enable-ADAccount -Identity $($User.username)
        Write-Host "Enabled user $($User.username)"
} else {
    Write-Host "User $($User.username) is already enabled"
    }
}