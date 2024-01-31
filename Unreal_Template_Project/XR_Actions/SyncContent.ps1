<#
.Description
This script is used to upload content to a gcs bucket. The script gets the
gcs bucket and uploads the current directory to the specified gcs bucket.
.PARAMETER gcs_bucket
.EXAMPLE
PS> .\XRActions\SyncContent.ps1 my-gcs-bucket.
This script is used to upload content to a gcs bucket.
#>
param(
  [parameter(mandatory)] [string] $gcs_bucket,
  [switch]$is_silent = $false
)

function Convert-LineEndings {
  param (
    $File
  )
  write-host("Converting line endings for ${File}...")
  ((Get-Content $File) -join "`n") + "`n" | Set-Content -NoNewline $File
}

$ProjectPath = Resolve-Path -Path "${PSScriptRoot}\.."

# Get first uproject file (there should not be multiple)
$ProjectFile = (Get-ChildItem -Path "${ProjectPath}" -Name -Filter *.uproject  | Select-Object -First 1)
$SyncFiles = @($ProjectFile, "CHANGELOG.md", "XR_Template.png")

$FoldersList = @("Content", "Config", "Cloud", "ImEdgeActions", "ToBuild", "Source", "Plugins")
# Add folders to the list of synced folder only if they exist
$SyncFolders = @()
Foreach ($Folder in $FoldersList) {
  if (Test-Path -Path ${ProjectPath}\${Folder})
  {
    $SyncFolders += $Folder
  }
}
# Set join string for arrays
$ofs = ', '
Write-Host "Sync the following files and folders to gs://${gcs_bucket}:"
Write-Host "Files: $SyncFiles"
Write-Host "Folders: $SyncFolders"
if (-not $is_silent) {
  $okToProceed = Read-Host -Prompt "Proceed? (Y/n)"
  if ($okToProceed -ne "Y") {
    exit
  }
}

Write-Host "Deleting all *.uproject files..."
gsutil rm gs://${gcs_bucket}/*.uproject

Foreach ($SyncFile in $SyncFiles) {
  Write-Host "Copying file ""$SyncFile""..."
  gsutil cp ${ProjectPath}\${SyncFile} gs://${gcs_bucket}/${SyncFile}
}

Foreach ($SyncFolder in $SyncFolders) {
  Write-Host "Synching folder ""$SyncFolder""..."
  gsutil -m rsync -r -d ${ProjectPath}\${SyncFolder} gs://${gcs_bucket}/${SyncFolder}
}

Write-Host "All files uploaded."
