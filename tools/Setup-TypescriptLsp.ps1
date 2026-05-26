$ErrorActionPreference = 'Stop'

$project = Join-Path -Path $PSScriptRoot -ChildPath 'typescript-lsp-shim\ts-shim.csproj'
$out = Join-Path -Path $PSScriptRoot -ChildPath 'typescript-lsp-shim\out'
$npm = Join-Path -Path $env:APPDATA -ChildPath 'npm'

Write-Host "Installing typescript-language-server and typescript..."
npm install -g typescript-language-server typescript
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Compiling .exe shim..."
dotnet publish $project --configuration Release --output $out
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Installing shim to npm global bin..."
Copy-Item -Path (Join-Path -Path $out -ChildPath 'typescript-language-server.exe') -Destination $npm -Force

Write-Host "Done. Restart Claude Code to activate the TypeScript LSP."
