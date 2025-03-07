# Define CSV file path
$csvFile = "exportGroup_2025-3-7.csv"

# Check if the file exists
if (-Not (Test-Path $csvFile)) {
    Write-Host "CSV file not found: $csvFile" -ForegroundColor Red
    exit
}

# Read the CSV file
$groups = Import-Csv -Path $csvFile

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

        # Display members' details
        $members | Select-Object displayName, userPrincipalName, objectId | Format-Table -AutoSize
    } else {
        Write-Host "No members found or error retrieving members for group: $groupName" -ForegroundColor Red
    }
}
