# Script: Ops 301 Final Project: Night Owl Network 
# Author: Connie Uribe Chavez
# Date of lates revision: 04 Apr 2023
# Purpose: AD Powershell Scripting
# Reference: https://woshub.com/powershell-configure-windows-networking/



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

#END
