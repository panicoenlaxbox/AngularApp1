$ErrorActionPreference = 'Stop'

$root = Split-Path -Path $PSScriptRoot -Parent
$dist = Join-Path -Path $root -ChildPath 'dist'
$wwwroot = Join-Path -Path $dist -ChildPath 'wwwroot'
$project = Join-Path -Path $root -ChildPath 'Server\src\WebApplication1\WebApplication1.csproj'
$client = Join-Path -Path $root -ChildPath 'client\app1'

if (Test-Path -Path $dist) {
    Remove-Item -Path $dist -Recurse -Force
}

dotnet publish $project --configuration Release --output $dist

New-Item -ItemType Directory -Path $wwwroot

Push-Location -Path $client
try {
    npx ng build --configuration production --output-path $wwwroot
}
finally {
    Pop-Location
}

Remove-Item -Path "$wwwroot\3rdpartylicenses.txt" -ErrorAction SilentlyContinue

if (Test-Path -Path "$wwwroot\browser") {
    Copy-Item -Path "$wwwroot\browser\*" -Destination $wwwroot -Recurse
    Remove-Item -Path "$wwwroot\browser" -Recurse -Force
}
