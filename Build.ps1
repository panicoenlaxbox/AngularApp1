if (Test-Path -Path .\dist) {
    Remove-Item -Path .\dist -Recurse -Force
}
dotnet publish .\Server\src\WebApplication1\WebApplication1.csproj --configuration Release --output .\dist
New-Item -ItemType Directory -Path .\dist\wwwroot
Set-Location -Path .\client\app1
ng build --configuration production --output-path ..\..\dist\wwwroot
Set-Location -path ..\..\
Remove-Item -Path .\dist\wwwroot\3rdpartylicenses.txt
Copy-Item -Path .\dist\wwwroot\browser\* -Destination .\dist\wwwroot -Recurse
Remove-Item -Path .\dist\wwwroot\browser -Recurse -Force
