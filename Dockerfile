FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY dist/ .
EXPOSE 8080
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
