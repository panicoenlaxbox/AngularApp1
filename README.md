# AngularApp1

This monorepo contains an Angular application and an ASP.NET Core Web API project.

## Client

```powershell
cd .\client\app1
npm install
npm start
```

## Server

```powershell
cd .\Server\src\WebApplication1
dotnet run
```

## Build
```powershell
.\Build.ps1
```

## Publish
```powershell
az login --tenant <YOUR_TENANT_ID>
.\Publish.ps1
```

```powershell
az login
az account list --query "[?name=='Visual Studio Professional'].[id:id, name:name, tenantId:tenantId]"
az account set --subscription <YOUR_SUBSCRIPTION_ID>
az account show
.\Publish.ps1
```