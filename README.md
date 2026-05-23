# AngularApp1

This monorepo contains an Angular application and an ASP.NET Core Web API project that is deployed to Azure App Service.

## How it works

**Development**: the Angular dev server runs on its own port. [`proxy.conf.json`](client/app1/src/proxy.conf.json) proxies `/api/*` requests to the ASP.NET server, so Angular components call `/api/...` without hardcoding any URL. CORS is enabled on the API to allow cross-origin requests from the Angular dev server.

**Production**: [`Build.ps1`](scripts/Build.ps1) compiles Angular and copies the output to `wwwroot/` inside the ASP.NET project. Both are served from the same domain, so no CORS is needed. `UseDefaultFiles` + `UseStaticFiles` serves the Angular app, and `MapFallbackToFile("/index.html")` ensures Angular's client-side routing works when navigating directly to a route or refreshing the page.

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
To test the production build locally before publishing:
```powershell
.\scripts\Build.ps1
cd .\dist
.\WebApplication1.exe
```

## Publish
```powershell
az login --tenant <YOUR_TENANT_ID>
.\scripts\Publish.ps1
```

## .editorconfig

```powershell
cd .\Server
dotnet format
cd ..
editorconfig-checker
```

> [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) validates all files against `.editorconfig` rules. Install with `npm install -g editorconfig-checker`.
