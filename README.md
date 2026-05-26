# AngularApp1

This monorepo contains an Angular application and an ASP.NET Core Web API project.

## How it works

**Development**: the Angular dev server runs on its own port. [`proxy.conf.json`](client/app1/src/proxy.conf.json) proxies `/api/*` requests to the ASP.NET server, so Angular components call `/api/...` without hardcoding any URL. CORS is enabled on the API to allow cross-origin requests from the Angular dev server.

**Production**: [`Build.ps1`](scripts/Build.ps1) compiles Angular and copies the output to `wwwroot/` inside the ASP.NET project. Both are served from the same domain, so no CORS is needed. `UseDefaultFiles` + `UseStaticFiles` serves the Angular app, and `MapFallbackToFile("/index.html")` ensures Angular's client-side routing works when navigating directly to a route or refreshing the page.

## Setup

After cloning, restore the .NET local tools and install the Git hooks:

```powershell
dotnet tool restore
dotnet husky install
```

### Claude Code LSP plugins

The project uses Claude Code's `csharp-lsp` and `typescript-lsp` plugins for code intelligence. Install the required binaries once after cloning:

**C# LSP** (all platforms):
```powershell
dotnet tool install --global csharp-ls
```

**TypeScript LSP** (Windows only):

```powershell
.\tools\Setup-TypescriptLsp.ps1
```

On Windows, npm installs `typescript-language-server` as a `.cmd` file that Claude Code cannot invoke directly. The script compiles a small `.exe` shim and places it in the npm global bin. Restart Claude Code afterwards.

On macOS/Linux the npm binary works natively — just install the package:

```bash
npm install -g typescript-language-server typescript
```

## Development

### Client

```powershell
cd .\client\app1
npm install
npm start
```

### Server

```powershell
cd .\Server\src\WebApplication1
dotnet run
```

### Linting

```powershell
cd .\Server
dotnet format
cd ..
editorconfig-checker
```

> [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) validates all files against `.editorconfig` rules. Install with `npm install -g editorconfig-checker`.

VS Code: follow the [workspace recommendations](.vscode/extensions.json) to install the [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) extension. Visual Studio has built-in support.

### Coverage
```powershell
.\scripts\Server-Coverage.ps1
```

Optionally filter by project name:
```powershell
.\scripts\Server-Coverage.ps1 -Filter MyProject
```

## Deployment

### Build
To test the production build locally before publishing:

```powershell
.\scripts\Build.ps1
cd .\dist
.\WebApplication1.exe
```

Alternatively, run it in Docker:

```powershell
.\scripts\Run-Docker.ps1
```

### Publish to App Service
```powershell
az login --tenant <YOUR_TENANT_ID>
.\scripts\Publish-AppService.ps1
```

### Publish to Container Apps
```powershell
az login --tenant <YOUR_TENANT_ID>
.\scripts\Publish-ContainerApp.ps1 -Suffix <YOUR_UNIQUE_SUFFIX>
```

`-Suffix` is required because Azure Container Registry names must be globally unique. Choose any short alphanumeric string (e.g. `-Suffix x7k2p` → `crwebapplication1x7k2p`).
