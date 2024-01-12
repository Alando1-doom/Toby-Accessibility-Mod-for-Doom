$archiveName = "TobyAccessibilityMod.zip"
$pk3Name = "TobyAccessibilityMod.pk3"
$compiledFolderName = "compiled-pk3"

$currentFolder = Get-Item -LiteralPath ".\"
$savePath = Join-Path $currentFolder $compiledFolderName
$finalSavePath = Join-Path $savePath $archiveName
$pk3SavePath = Join-Path $savePath $pk3Name

$excludeList = @(".git", ".gitignore", $MyInvocation.MyCommand.Name, $compiledFolderName)
$itemsToArchive = Get-ChildItem -Path $folderPath | Where-Object { $_.Name -notin $excludeList }

if (Test-Path $finalSavePath) {
    Write-Host "Removing old .zip file..."
    Remove-Item $finalSavePath -Force
    Write-Host "Done!"
    Write-Host ""
}
if (Test-Path $pk3SavePath) {
    Write-Host "Removing old .pk3 file..."
    Remove-Item $pk3SavePath -Force
    Write-Host "Done!"
    Write-Host ""
}

Write-Host "Archiving..."
Compress-Archive -Path $itemsToArchive.FullName -DestinationPath $finalSavePath -CompressionLevel 'NoCompression'
Write-Host "Done!"

Write-Host ""
Write-Host "Renaming to .pk3..."
Rename-Item -Path $finalSavePath -NewName $pk3Name
Write-Host "Done!"

Write-Host ""
Write-Host ".pk3 file created at: "
Write-Host $pk3SavePath

Write-Host ""
Write-Host "Press any key to close this powershell window..."
$key = [System.Console]::ReadKey()
