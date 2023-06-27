# Retrieve the current user's SID
$currentUserName = $env:USERNAME
$currentUserSID = (New-Object System.Security.Principal.NTAccount($currentUserName)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Define the root directory to search for DLL files
$rootDirectory = "C:\"   # Update with your desired directory

# Recursively search for DLL files
$dllFiles = Get-ChildItem -Path $rootDirectory -Filter "*.dll" -Recurse -File

# Iterate through each DLL file
foreach ($file in $dllFiles) {
    try {
        # Get the ACL (Access Control List) for the file
        $acl = Get-Acl -Path $file.FullName

        # Check if the DLL file has RWX permissions for the current user
        $hasRWXPermissions = $false
        foreach ($ace in $acl.Access) {
            if ($ace.IdentityReference.Value -eq $currentUserSID -and $ace.FileSystemRights -band 'Read,Write,Execute' -eq 'Read,Write,Execute') {
                $hasRWXPermissions = $true
                break
            }
        }

        # Print the DLL file path if it has RWX permissions for the current user
        if ($hasRWXPermissions) {
            Write-Host "Legitimate DLL with RWX permissions for current user: $($file.FullName)"
        }
    }
    catch {
        # Ignore any errors encountered while accessing files or checking permissions
        continue
    }
}
