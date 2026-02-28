$currentFolder = Get-Item -LiteralPath ".\"
$folderName = $currentFolder.Name

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$archiveName = "$folderName`_$timestamp.zip"
$pk3Name     = "$folderName`_$timestamp.pk3"
$compiledFolderName = "compiled-pk3"

$currentFolder = Get-Item -LiteralPath ".\"
$savePath = Join-Path $currentFolder $compiledFolderName

if (-not (Test-Path -Path $savePath -PathType Container)) {
    Write-Host "Creating ""$compiledFolderName"" folder..."
    New-Item -ItemType Directory -Path $savePath -Force | Out-Null
    Write-Host "Done!`n"
}

$finalSavePath = Join-Path $savePath $archiveName
$pk3SavePath = Join-Path $savePath $pk3Name

$excludeList = @(".git", ".gitignore", $MyInvocation.MyCommand.Name, $compiledFolderName)
$itemsToArchive = Get-ChildItem -Path $folderPath | Where-Object { $_.Name -notin $excludeList }

if (Test-Path $finalSavePath) {
    Write-Host "Removing old .zip file..."
    Remove-Item $finalSavePath -Force
    Write-Host "Done!`n"
}
if (Test-Path $pk3SavePath) {
    Write-Host "Removing old .pk3 file..."
    Remove-Item $pk3SavePath -Force
    Write-Host "Done!`n"
}

Write-Host "Archiving..."
Compress-Archive -Path $itemsToArchive.FullName -DestinationPath $finalSavePath -CompressionLevel 'NoCompression'
Write-Host "Done!`n"

Write-Host "Renaming to .pk3..."
Rename-Item -Path $finalSavePath -NewName $pk3Name
Write-Host "Done!`n"

Write-Host ".pk3 file created at: "
Write-Host "$pk3SavePath`n"
