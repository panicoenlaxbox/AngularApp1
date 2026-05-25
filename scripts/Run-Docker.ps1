.$PSScriptRoot\Build.ps1

$root = Split-Path -Path $PSScriptRoot -Parent

docker build --tag webapplication1 --file (Join-Path -Path $root -ChildPath 'Dockerfile') $root
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

docker run --rm -d -p 8080:8080 webapplication1
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Start-Process -FilePath 'http://localhost:8080'
