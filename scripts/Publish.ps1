.$PSScriptRoot\Build.ps1
.$PSScriptRoot\Utils.ps1

$root = Split-Path -Path $PSScriptRoot -Parent
$dist = Join-Path -Path $root -ChildPath 'dist'
$zip = Join-Path -Path $dist -ChildPath 'dist.zip'

$resourceGroupName = "rg-webapplication1"
$location = "spaincentral"
$servicePlanName = "asp-sergio"
$webAppName = "app-webapplication1"

Invoke-Az group create --name $resourceGroupName --location $location

Invoke-Az appservice plan create --name $servicePlanName --resource-group $resourceGroupName --location $location --sku FREE --is-linux

Invoke-Az webapp create --resource-group $resourceGroupName --plan $servicePlanName --name $webAppName --runtime "DOTNETCORE:10.0"

Compress-Archive -Path "$dist\*" -DestinationPath $zip

Invoke-Az webapp deploy --resource-group $resourceGroupName --name $webAppName --src-path $zip --type zip

$url = Invoke-Az webapp show --name $webAppName --resource-group $resourceGroupName --query "defaultHostName" -o tsv

Write-Host "https://$url"
