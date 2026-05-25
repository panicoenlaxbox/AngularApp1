param(
    [Parameter(Mandatory)]
    [string]$Suffix
)

.$PSScriptRoot\Build.ps1

.$PSScriptRoot\Utils.ps1

$root = Split-Path -Path $PSScriptRoot -Parent

$location = 'spaincentral'
$resourceGroupName = 'rg-webapplication1'
$logAnalyticsName = 'log-webapplication1'
$containerRegistryName = "crwebapplication1${Suffix}"
$environmentName = 'cae-webapplication1'
$containerAppName = 'ca-webapplication1'
$imageName = 'webapplication1'

Write-Host "Creating resource group..."
Invoke-Az group create `
    --name $resourceGroupName `
    --location $location

Write-Host "Creating Log Analytics workspace..."
$logAnalytics = Invoke-Az monitor log-analytics workspace create `
    --resource-group $resourceGroupName `
    --workspace-name $logAnalyticsName `
    --location $location `
    --query "{id:id, customerId:customerId}" `
    --output json | ConvertFrom-Json

$logAnalyticsKey = Invoke-Az monitor log-analytics workspace get-shared-keys `
    --resource-group $resourceGroupName `
    --workspace-name $logAnalyticsName `
    --query "primarySharedKey" -o tsv

Write-Host "Creating Container Registry..."
Invoke-Az acr create `
    --name $containerRegistryName `
    --resource-group $resourceGroupName `
    --location $location `
    --sku Basic `
    --admin-enabled true

Write-Host "Creating Container Apps environment..."
Invoke-Az containerapp env create `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --location $location `
    --logs-workspace-id $logAnalytics.customerId `
    --logs-workspace-key $logAnalyticsKey

$imageTag = Get-Date -Format 'yyyyMMddHHmmss'

Write-Host "Logging into ACR..."
Invoke-Az acr login --name $containerRegistryName

$loginServer = Invoke-Az acr show `
    --name $containerRegistryName `
    --query "loginServer" -o tsv

$fullImage = "${loginServer}/${imageName}:${imageTag}"

Write-Host "Building Docker image (tag: $imageTag)..."
docker build --tag $fullImage --file (Join-Path -Path $root -ChildPath 'Dockerfile') $root
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Pushing Docker image..."
docker push $fullImage
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$registryPassword = Invoke-Az acr credential show `
    --name $containerRegistryName `
    --query "passwords[0].value" -o tsv

$envVars = @(
    "ASPNETCORE_ENVIRONMENT=Production"
)

Write-Host "Deploying Container App..."
$containerAppExists = az containerapp list `
    --resource-group $resourceGroupName `
    --query "[?name=='$containerAppName'].name" -o tsv

if ($containerAppExists) {
    Invoke-Az containerapp update `
        --name $containerAppName `
        --resource-group $resourceGroupName `
        --image $fullImage `
        --set-env-vars $envVars
}
else {
    Invoke-Az containerapp create `
        --name $containerAppName `
        --resource-group $resourceGroupName `
        --environment $environmentName `
        --image $fullImage `
        --registry-server $loginServer `
        --registry-username $containerRegistryName `
        --registry-password $registryPassword `
        --ingress external `
        --target-port 8080 `
        --transport auto `
        --min-replicas 0 `
        --max-replicas 1 `
        --env-vars $envVars
}

$fqdn = Invoke-Az containerapp show `
    --name $containerAppName `
    --resource-group $resourceGroupName `
    --query "properties.configuration.ingress.fqdn" -o tsv

Write-Host "Deployment complete. URL: https://$fqdn"
