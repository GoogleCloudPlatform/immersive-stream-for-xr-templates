<#
.Description
This script is used to upload content to a project. The script gets the
project and the content as parameters, uploads the current directory to the
specified stream content and waits for the build to finish.
.PARAMETER project_id
The id of the project where stream api is enabled and hosts the gcs bucket.
.PARAMETER content_id
The id of the content created with stream api.
.PARAMETER version_tag
Adds the tag to the content being uploaded.
.EXAMPLE
PS> .\ImEdgeActions\SyncContent.ps1 my-stream-project -content_id my-content
-version_tag my-version-tag
.SYNOPSIS
This script is used to upload content to a project.
#>
param(
  [parameter(mandatory)] [string] $project_id,
  [parameter(mandatory)] [string] $content_id,
  [parameter(mandatory)] [string] $version_tag,
  [switch]$is_silent = $false
)


function Convert-LineEndings {
  param (
    $File
  )
  write-host("Converting line endings for ${File}...")
  ((Get-Content $File) -join "`n") + "`n" | Set-Content -NoNewline $File
}

# Check the status of content
Write-Host "Checking status of content with id ${content_id}."
$content_response=&"${PSScriptRoot}\DescribeContent.ps1" -project_id ${project_id} -content_id ${content_id}
If ($content_response.lifeCycleState.state -ne "READY") {
  throw "The content with id $content_id is not READY"
}

$gcs_bucket=$content_response.bucketName
$ProjectPath = Resolve-Path -Path "${PSScriptRoot}\.."

# Get first uproject file (there should not be multiple)
$ProjectFile = (Get-ChildItem -Path "${ProjectPath}" -Filter *.uproject  | Select-Object -First 1)
$SyncFiles = @($ProjectFile, "CHANGELOG.md", "ImEdgeTemplate.png")
$FoldersList = @("Content", "Config", "Cloud", "ImEdgeActions", "ToBuild", "Source", "Plugins", "ToCustomize")
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
& {
  $LogFolderLocal = "${ProjectPath}\logs"
  If (!(test-path $LogFolderLocal)) {
    Write-Host "Creating log folder:"
    mkdir $LogFolderLocal
  }
  
  # Initiate the build
  $build_response=&"${PSScriptRoot}\BuildContent.ps1" -project_id $project_id -content_id $content_id -version_tag $version_tag
  if ($build_response.StatusCode -ne 200){
    throw "Failed to initiate the build."
  }
  # Start a loop to get the progress status and logs
  $build_finished=$false
  $progress="Waiting for build to start for version: $version_tag"
  do {
    Write-Progress -Activity "Building content: $content_id from project_id: $project_id"-Status $progress
    Start-Sleep 10

    $content_response=&"${PSScriptRoot}\DescribeContent.ps1" -project_id ${project_id} -content_id ${content_id}
    $description=$content_response.lifeCycleState.description
    If (-not ($description.Contains($version_tag))) {
      continue
    }
    $progress=$description
    If (($description -like "*failed*") -or ($description -like "*FAILURE*")) {
      $build_finished=$true
      throw $description
    }
    If ($description -like "*finished*") {
      $build_finished=$true
    }
  }
  while(-not($build_finished))
  Write-Host $progress
  Write-Host "Build finished. You can roll out the new build to your instance if there are no errors."

}
