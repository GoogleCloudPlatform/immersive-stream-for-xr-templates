<#
.Description
Describes an instance created with the stream api.
.PARAMETER project_id
The id of the project where stream api is enabled.
.PARAMETER instance_id
The id of the instance created with stream api.
.EXAMPLE
PS> .\ImEdgeActions\DescribeInstance.ps1 my-stream-project -instance_id
my-instance
.SYNOPSIS
Describes an instance created with stream api.
#>
param(
  [parameter(mandatory)] [string] $project_id,
  [parameter(mandatory)] [string] $instance_id
)

$API="stream.googleapis.com"
$API_VERSION="v1alpha1"
$LOCATION="global"
$ENDPOINT="https://${API}/${API_VERSION}/projects/${project_id}/locations/${LOCATION}"
$TOKEN=gcloud auth print-access-token

$headers = @{"Authorization" = "Bearer $TOKEN"; "Content-Type" = "application/json" }
$response = Invoke-RestMethod -Method Get -Headers $headers -Uri "${ENDPOINT}/streamInstances/$instance_id"
return $response



