param(
  [Parameter(Mandatory = $false)]
  [string]$Filter
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Path $PSScriptRoot -Parent

$solution = Join-Path -Path $root -ChildPath 'Server\WebApplication1.slnx'

Write-Host "Building solution $solution"

dotnet build $solution

$coverage = Join-Path -Path $root -ChildPath 'Server\coverage'

Write-Host "Coverage output directory: $coverage"

if (Test-Path -Path $coverage) {
  Write-Host "Removing existing coverage directory: $coverage"
  Remove-Item -Path $coverage -Recurse -Force
}

$coverageReport = Join-Path -Path $root -ChildPath 'Server\coveragereport'

Write-Host "Coverage report directory: $coverageReport"

if (Test-Path -Path $coverageReport) {
  Write-Host "Removing existing coverage report directory: $coverageReport"
  Remove-Item -Path $coverageReport -Recurse -Force
}

$projects = Get-ChildItem -Path (Join-Path -Path $root -ChildPath 'Server\tests') -Recurse -Filter *.csproj

$projects | ForEach-Object { Write-Host "Found test project: $($_.FullName)" }

if ($Filter) {
  Write-Host "Filtering projects with filter: $Filter"
  $projects = $projects | Where-Object { $_.BaseName -like "*$Filter*" }
}

Write-Host "Total test projects to run coverage on: $($projects.Count)"

$current = 1
foreach ($project in $projects) {
  $coverletOutput = Join-Path -Path $coverage -ChildPath $project.BaseName

  Write-Host ("Running coverage for project: {0} ({1}/{2})" -f $project.FullName, $current, $projects.Count)

  dotnet test `
    $project.FullName `
    --no-build `
    --logger "console;verbosity=normal" `
    /p:CollectCoverage=true `
    /p:CoverletOutputFormat=cobertura `
    /p:CoverletOutput="$coverletOutput/" `
    /p:ExcludeByFile="**/obj/**"

  $current++
}

$reportFiles = Get-ChildItem -Path $coverage -Recurse -Filter "coverage.cobertura.xml" | ForEach-Object {
  $_.FullName
}

$reports = $reportFiles -join ";"

Write-Host "Generating coverage report in: $coverageReport from reports: $reports"

dotnet reportgenerator `
  -reports:"$reports" `
  -targetdir:$coverageReport `
  -reporttypes:Html

Write-Host "Opening coverage report..."

Start-Process -FilePath (Join-Path -Path $coverageReport -ChildPath 'index.html')
