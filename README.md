# AngularApp1

This monorepo contains an Angular application and an ASP.NET Core Web API project that is deployed to Azure App Service.

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
.\scripts\Build.ps1
```

## Publish
```powershell
az login --tenant <YOUR_TENANT_ID>
.\scripts\Publish.ps1
```
