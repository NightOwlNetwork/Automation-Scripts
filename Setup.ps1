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

# Set the path to the PowerShell script to run after the restart
$scriptPath = "C:\User\Administrator\Documents\Startup2.ps1"

# Create a new scheduled task
$action = New-ScheduledTaskAction -Execute "Startup2.ps1" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings (New-ScheduledTaskSettingsSet)
Register-ScheduledTask -TaskName "Run Script After Restart" -InputObject $task


# Restart the server to complete the installation
Restart-Computer


