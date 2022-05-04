<#
.Description
This script initiates a build for a content that is uploaded to the
corresponding gcs bucket and tags it with the specified tag.
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
This script initiates a build for a content that.
#>
param(
  [parameter(mandatory)] [string] $project_id,
  [parameter(mandatory)] [string] $content_id,
  [parameter(mandatory)] [string] $version_tag
)

$API="stream.googleapis.com"
$API_VERSION="v1alpha1"
$LOCATION="global"
$ENDPOINT="https://${API}/${API_VERSION}/projects/${project_id}/locations/${LOCATION}"
$TOKEN=gcloud auth print-access-token
$body=@{
    content_version_tag=$version_tag
}
$json_body = $body | ConvertTo-Json
echo $body
echo $json_body
$headers = @{"Authorization" = "Bearer $TOKEN"}
$response = 
  Invoke-WebRequest `
    -Method Post `
    -Headers $headers `
    -Body $json_body `
    -ContentType: "application/json; charset=utf-8" `
    -Uri "${ENDPOINT}/streamContents/$content_id\:build"
return $response



