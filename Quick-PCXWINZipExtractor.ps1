<#
.SYNOPSIS
The Quick-PCXWINZipExtractor.ps1 script automates the extraction of ZIP files in the current directory. 
It efficiently handles nested ZIP files by recursively processing them if they contain only a single 
ZIP file inside. The script exits when multiple files or folders are detected within a ZIP, ensuring 
that the directory remains organized and free of redundant ZIP archives.

.DESCRIPTION
This script extracts all ZIP files in the specified directory, checking each one for nested ZIPs. 
If a nested ZIP is found and it's the only file in the directory, it replaces the outer ZIP with 
the nested one and continues processing. The script stops once all ZIPs have been extracted and 
no further nested ZIPs are found. This is particularly useful for organizing and simplifying directories 
that contain complex ZIP structures.

.PARAMETER zipFile
The full path to the ZIP file that needs to be processed.

.EXAMPLE
.\Quick-PCXWINZipExtractor.ps1
This example runs the script in the current directory, extracting all ZIP files and handling any nested ZIPs.

.NOTES
Author: HarshBharath
Date: 22-08-2024
Version: 5.35 
#>


function Process-Zip {
    param (
        [string]$zipFile
    )

    # Extract the zip file
    Expand-Archive -Path $zipFile -DestinationPath .

    $folderName = $zipFile -replace '\.zip$'
    $files = Get-ChildItem -Path $folderName -ErrorAction SilentlyContinue

    if ($files -and $files.Count -eq 1 -and $files.Name -like '*.zip') {
        $newZipFile = Join-Path -Path $folderName -ChildPath $files.Name
        Remove-Item -Path $zipFile -Force
        Move-Item -Path $newZipFile -Destination .
        Remove-Item -Path $folderName -Force
        Process-Zip -zipFile $files.Name  # Recursive call
    }
    elseif ($files -and ($files.Count -gt 1 -or $files | Where-Object { $_.PSIsContainer })) {
        Write-Output "Found more than 1 file or folder inside $folderName. Exiting."
    }
    else {
        Write-Output "Done processing $zipFile."
    }
}

# Set the current directory as the directory where your zip files are located.
$directory = Get-Location

if (Test-Path -Path $directory -PathType Container) {
    # Loop through each file in the directory
    Get-ChildItem -Path $directory -Filter *.zip | ForEach-Object {
        Process-Zip -zipFile $_.FullName
    }
}
else {
    Write-Output "The specified directory $directory does not exist."
}
