.$PSScriptRoot\Build.ps1

$root = Split-Path -Path $PSScriptRoot -Parent
$dist = Join-Path -Path $root -ChildPath 'dist'
$zip = Join-Path -Path $dist -ChildPath 'dist.zip'

$resourceGroupName = "rg-webapplication1"
$location = "spaincentral"
$servicePlanName = "asp-sergio"
$webAppName = "app-webapplication1"

az group create --name $resourceGroupName --location $location

az appservice plan create --name $servicePlanName --resource-group $resourceGroupName --location $location --sku FREE --is-linux

az webapp create --resource-group $resourceGroupName --plan $servicePlanName --name $webAppName --runtime "DOTNETCORE:10.0"

Compress-Archive -Path "$dist\*" -DestinationPath $zip

az webapp deploy --resource-group $resourceGroupName --name $webAppName --src-path $zip --type zip

$url = $(az webapp show --name $webAppName --resource-group $resourceGroupName --query "defaultHostName" -o tsv)

Write-Host "https://$url"
