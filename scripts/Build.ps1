$ErrorActionPreference = 'Stop'

$root = Split-Path -Path $PSScriptRoot -Parent
$distPath = Join-Path -Path $root -ChildPath 'dist'
$wwwrootPath = Join-Path -Path $distPath -ChildPath 'wwwroot'
$serverProject = Join-Path -Path $root -ChildPath 'Server\src\WebApplication1\WebApplication1.csproj'
$clientPath = Join-Path -Path $root -ChildPath 'client\app1'

if (Test-Path -Path $distPath) {
    Remove-Item -Path $distPath -Recurse -Force
}

dotnet publish $serverProject --configuration Release --output $distPath

New-Item -ItemType Directory -Path $wwwrootPath

Push-Location -Path $clientPath
try {
    npx ng build --configuration production --output-path $wwwrootPath
}
finally {
    Pop-Location
}

Remove-Item -Path "$wwwrootPath\3rdpartylicenses.txt" -ErrorAction SilentlyContinue

if (Test-Path -Path "$wwwrootPath\browser") {
    Copy-Item -Path "$wwwrootPath\browser\*" -Destination $wwwrootPath -Recurse
    Remove-Item -Path "$wwwrootPath\browser" -Recurse -Force
}
