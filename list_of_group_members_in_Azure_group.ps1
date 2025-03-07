#pre requirements: 
# az login ; authenticate your account 
# ps ; powershell needs to be installed 
# Define file paths
$csvFile = "/Users/moh/Downloads/exportGroup_2025-3-7.csv"
$outputFile = "/Users/moh/Downloads/GroupMembers_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').csv"

# Check if the input file exists
if (-Not (Test-Path $csvFile)) {
    Write-Host "CSV file not found: $csvFile" -ForegroundColor Red
    exit
}

# Read the CSV file
$groups = Import-Csv -Path $csvFile

# Initialize an array to store results
$allMembers = @()

# Iterate over each group in the CSV
foreach ($group in $groups) {
    $groupName = $group.displayName  # Extract group name

    if (-not $groupName) {
        Write-Host "Skipping empty group name entry..." -ForegroundColor Yellow
        continue
    }

    Write-Host "Fetching members for group: $groupName" -ForegroundColor Cyan

    # Run Azure CLI command to get group members
    $membersJson = az ad group member list --group "$groupName" --output json

    if ($membersJson) {
        # Convert JSON output to PowerShell object
        $members = $membersJson | ConvertFrom-Json

        # Append members' details to array
        foreach ($member in $members) {
            $allMembers += [PSCustomObject]@{
                GroupName         = $groupName
                MemberDisplayName = $member.displayName
                UserPrincipalName = $member.userPrincipalName
                ObjectId          = $member.id
            }
        }
    } else {
        Write-Host "No members found or error retrieving members for group: $groupName" -ForegroundColor Red
    }
}

# Export results to CSV
if ($allMembers.Count -gt 0) {
    $allMembers | Export-Csv -Path $outputFile -NoTypeInformation
    Write-Host "Results saved to: $outputFile" -ForegroundColor Green
} else {
    Write-Host "No data to export." -ForegroundColor Yellow
}
