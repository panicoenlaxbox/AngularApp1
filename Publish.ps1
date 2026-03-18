.\Build.ps1

$resourceGroupName = "rg-webapplication1"
$location = "spaincentral"
$servicePlanName = "asp-sergio"
$webAppName = "app-webapplication1"

az group create --name $resourceGroupName --location $location
az appservice plan create --name $servicePlanName --resource-group $resourceGroupName --location $location --sku FREE --is-linux
# az webapp list-runtimes --os-type linux
az webapp create --resource-group $resourceGroupName --plan $servicePlanName --name $webAppName --runtime "DOTNETCORE:10.0"
Compress-Archive -Path .\dist\* -DestinationPath .\dist\dist.zip
az webapp deploy --resource-group $resourceGroupName --name $webAppName --src-path .\dist\dist.zip --type zip
$url = $(az webapp show --name $webAppName --resource-group $resourceGroupName --query "defaultHostName" -o tsv)
Write-Host "https://$url"
