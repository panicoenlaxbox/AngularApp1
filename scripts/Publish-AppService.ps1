.$PSScriptRoot\Build.ps1
.$PSScriptRoot\Utils.ps1

$root = Split-Path -Path $PSScriptRoot -Parent
$dist = Join-Path -Path $root -ChildPath 'dist'
$zip = Join-Path -Path $dist -ChildPath 'dist.zip'

$resourceGroupName = "rg-webapplication1"
$location = "spaincentral"
$logAnalyticsName = "log-webapplication1"
$appInsightsName = "ai-webapplication1"
$servicePlanName = "asp-sergio"
$webAppName = "app-webapplication1"

Invoke-Az group create --name $resourceGroupName --location $location

Write-Host "Creating Log Analytics workspace..."
$logAnalytics = Invoke-Az monitor log-analytics workspace create `
    --resource-group $resourceGroupName `
    --workspace-name $logAnalyticsName `
    --location $location `
    --query "{id:id, customerId:customerId}" `
    --output json | ConvertFrom-Json

Write-Host "Creating Application Insights..."
$appInsightsConnectionString = Invoke-Az monitor app-insights component create `
    --app $appInsightsName `
    --resource-group $resourceGroupName `
    --location $location `
    --workspace $logAnalytics.id `
    --kind web `
    --application-type web `
    --query "connectionString" -o tsv

Invoke-Az appservice plan create --name $servicePlanName --resource-group $resourceGroupName --location $location --sku FREE --is-linux

Invoke-Az webapp create --resource-group $resourceGroupName --plan $servicePlanName --name $webAppName --runtime "DOTNETCORE:10.0"

Compress-Archive -Path "$dist\*" -DestinationPath $zip

Invoke-Az webapp deploy --resource-group $resourceGroupName --name $webAppName --src-path $zip --type zip

Write-Host "Connecting Application Insights..."
Invoke-Az webapp config appsettings set `
    --name $webAppName `
    --resource-group $resourceGroupName `
    --settings "APPLICATIONINSIGHTS_CONNECTION_STRING=$appInsightsConnectionString"

$url = Invoke-Az webapp show --name $webAppName --resource-group $resourceGroupName --query "defaultHostName" -o tsv

Write-Host "https://$url"
