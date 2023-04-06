
#Installs Tools
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.tool~~~~0.0.1.0 -Online

Import-Module ActiveDirectory
# Prompt the user for the OU name
$ouNames = "Executive", "Engineering", "Project Management", "Sales & Marketing", "Customer Successs", "Operations", "Reseach & Delevoplment"
$domainDN = "DC=cleanpower,DC=com"
# Create the new OU
foreach ($ouName in $ouNames) {
    New-ADOrganizationalUnit -Name $ouName -Path $domainDN
}

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