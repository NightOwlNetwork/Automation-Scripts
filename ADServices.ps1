# Sierra Maldonado
# Auto Start for New User


# Set Execution Policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Check if the AD-Domain-Services role is already installed
$adRole = Get-WindowsFeature -Name AD-Domain-Services
if ($adRole.Installed -ne "True") {

    # Install the AD-Domain-Services role and management tools
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    
    Write-Output "AD-Domain-Services role and management tools installed successfully."

} else {
    Write-Output "AD-Domain-Services role is already installed."
}
