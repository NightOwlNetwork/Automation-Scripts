# Script: Ops 301 Final Project: Night Owl Network 
# Author: Connie Uribe Chavez
# Date of lates revision: 04 Apr 2023
# Purpose: AD Powershell Scripting
# Reference: https://woshub.com/powershell-configure-windows-networking/
# Reference: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-7.3


# MAIN

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

#END
