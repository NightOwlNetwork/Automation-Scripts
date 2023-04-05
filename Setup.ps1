# Nick, Sierra, Connie, Geneva
# Start from blank server script



# Set Execution Policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Assigns the Window Server VM a static IPv4 Address 
# Write-Host $adapter.name
$newip = Read-Host "What is the new IPv4 Address?"
Get-NetAdapter -name ethernet | New-NetIPAddress $newip #-DefaultGateway 192.168.1.1 -PrefixLength 24
(Get-NetAdapter -Name ethernet | Get-NetIPAddress).IPv4Address

# Assigns the Window Server VM a static DNS
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses
192.168.1.11,127.0.0.11
Get-DnsClientServerAddress

# Renames the Windows Server VM
Rename-Computer -NewName "Server044" -DomainCredential
CORP\administrator -Restart
ipconfig /all

# Check if the AD-Domain-Services role is already installed
$adRole = Get-WindowsFeature -Name AD-Domain-Services
if ($adRole.Installed -ne "True") {

    # Install the AD-Domain-Services role and management tools
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    
    Write-Output "AD-Domain-Services role and management tools installed successfully."

} else {
    Write-Output "AD-Domain-Services role is already installed."
}

# Prompt the user for the name of the new forest and domain
$forestName = Read-Host "Enter the name of the new forest"
$domainName = Read-Host "Enter the name of the new domain"

# Create the new forest using the Install-ADDSForest cmdlet
Install-ADDSForest -DomainName $domainName -DomainNetbiosName ($domainName.Split('.')[0]) -ForestMode WinThreshold -DomainMode WinThreshold -ForestName $forestName


# Prompt the user for the OU name
$ouName = Read-Host "Enter the name for the new OU"

# Prompt the user for the domain name
$domain = Read-Host "Enter the domain for the new OU"

# Create the new OU
New-ADOrganizationalUnit -Name $ouName -Path "DC=$domain,DC=com"

#Installs tools
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory

#Finds CSV file
$ADUser = Import-Csv "C:\Users\Administrator\Documents\CP.csv"

# For each, reads each line as a new user
Foreach ($User in $ADUser) {
    New-ADUser `
        -Name "$($user.firstname)  $($user.lastname)" `
        -Givenname $user.firstname `
        -Surname $user.lastname `
        -Enabled $true `
        -Path 'OU=$($user.OU),DC=cleanpower,DC=com' `
        -Title $user.jobtitle `
        -Email $user.email `
        -AccountPassword (ConvertTo-SecureString $user.password -AsPlaintext -Force)
}
echo "New Users Added"