<#
.Description
Describes a content created with stream api.
.PARAMETER project_id
The id of the project where stream api is enabled.
.PARAMETER content_id
The id of the content created with stream api.
.EXAMPLE
PS> .\ImEdgeActions\DescribeContent.ps1 my-stream-project -content_id my-content
.SYNOPSIS
Describes a content created with stream api.
#>
param(
  [parameter(mandatory)] [string] $project_id,
  [parameter(mandatory)] [string] $content_id
)

$API="stream.googleapis.com"
$API_VERSION="v1alpha1"
$LOCATION="global"
$ENDPOINT="https://${API}/${API_VERSION}/projects/${project_id}/locations/${LOCATION}"
$TOKEN=gcloud auth print-access-token

$headers = @{"Authorization" = "Bearer $TOKEN"; "Content-Type" = "application/json" }
$response = Invoke-RestMethod -Method Get -Headers $headers -Uri "${ENDPOINT}/streamContents/$content_id"
return $response



