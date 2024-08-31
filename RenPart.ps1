# Define the directory where your files are located
$directoryPath = "C:\Temp\Automation_Add_Pack_Apps_To_DPs"

# Define the substring you want to replace and its replacement
$oldSubstring = "butionP"
$newSubstring = "OOOOOOMEMMMM"

# Get all files in the directory
Get-ChildItem -Path $directoryPath -File | ForEach-Object {
    # Get the file name without extension
    $fileNameWithoutExtension = $_.BaseName

    # Check if the file name contains the old substring
    if ($fileNameWithoutExtension -match $oldSubstring) {
        # Replace the old substring with the new one
        $newFileNameWithoutExtension = $fileNameWithoutExtension -replace $oldSubstring, $newSubstring

        # Construct the new file name with the extension
        $newFileName = "$newFileNameWithoutExtension$($_.Extension)"

        # Rename the file
        Rename-Item -Path $_.FullName -NewName $newFileName
    }
}
