param(
    [string]$resourceGroupName,
    [string]$storageAccountName,
    [string]$sourceFolder
)

$containerName = "`$web"  # container used for static website hosting

# Get the storage account context
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$ctx = $storageAccount.Context

# Function to determine content type based on file extension
# TODO: Refactor to use a better solution
Function Get-ContentType {
    param (
        [string]$filePath
    )

    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
    switch ($extension) {
        ".html" { return "text/html" }
        ".css"  { return "text/css" }
        ".js"   { return "application/javascript" }
        ".eot"  { return "application/vnd.ms-fontobject" }
        ".svg"  { return "image/svg+xml" }
        ".ttf"  { return "application/font-sfnt" }
        ".woff" { return "font/woff" }
        ".woff2"{ return "font/woff2" }
        ".jpg"  { return "image/jpeg" }
        ".json" { return "application/json" }
        default { return "application/octet-stream" }
    }
}

# Function to upload files recursively to Azure Blob Storage
Function Upload-FilesToBlobStorage {
    param (
        [string]$sourcePath,
        [string]$containerName
    )
    
    $files = Get-ChildItem -Path $sourcePath -File -Recurse

    foreach ($file in $files) {
        $blobName = $file.FullName.Replace($sourcePath, "").TrimStart('\')
        $blobPath = "$containerName/$blobName"

        $contentType = Get-ContentType -filePath $file.FullName

        Write-Host "Uploading $blobPath with ContentType: $contentType"
        Set-AzStorageBlobContent -File $file.FullName -Container $containerName -Blob $blobName -Context $ctx -Properties @{"ContentType" = $contentType} -Force
    }
}

# Upload files and folders to the Blob Storage container
Upload-FilesToBlobStorage -sourcePath $sourceFolder -containerName $containerName

Write-Host "Upload completed successfully."
