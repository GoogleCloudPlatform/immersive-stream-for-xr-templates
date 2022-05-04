<#
.Description
Describes and lists all the instances created with stream api.
.PARAMETER project_id
The id of the project where stream api is enabled.
.EXAMPLE
PS> .\ImEdgeActions\DescribeInstances.ps1 my-stream-project
.SYNOPSIS
Describes and lists all the instances.
#>
param(
  [parameter(mandatory)] [string] $project_id
)

$API="stream.googleapis.com"
$API_VERSION="v1alpha1"
$LOCATION="global"
$ENDPOINT="https://${API}/${API_VERSION}/projects/${project_id}/locations/${LOCATION}"
$TOKEN=gcloud auth print-access-token

$headers = @{"Authorization" = "Bearer $TOKEN"; "Content-Type" = "application/json" }
$response = Invoke-RestMethod -Method Get -Headers $headers -Uri "${ENDPOINT}/streamInstances"
return $response.streamInstances





