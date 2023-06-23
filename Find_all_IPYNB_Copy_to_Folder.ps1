$drives = Get-PSDrive -PSProvider 'FileSystem' | Where-Object {$_.Free -gt 0}

$destinationFolder = 'C:\Users\User\Downloads\IPython_NB'
New-Item -ItemType Directory -Force -Path $destinationFolder | Out-Null

$files = foreach ($drive in $drives) {
    Get-ChildItem -Path "$($drive.Root)*.ipynb" -Recurse -ErrorAction SilentlyContinue
}

$files | ForEach-Object {
    $destinationPath = Join-Path -Path $destinationFolder -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $destinationPath -Force
}
