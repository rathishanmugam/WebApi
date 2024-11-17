# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the .csproj file separately first to ensure the build process can find it
COPY WebApi/*.csproj ./WebApi/

# Restore dependencies
RUN dotnet restore WebApi/WebApi.csproj

# Install dotnet-ef as a global tool
RUN dotnet tool install --global dotnet-ef

# Ensure dotnet-ef is on the PATH
ENV PATH="$PATH:/root/.dotnet/tools"

# Copy the rest of the application files into the container
COPY . ./

# Publish the application
RUN dotnet publish WebApi/WebApi.csproj -c Release -o /app/publish


# Final stage - runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

# Start the application
ENTRYPOINT ["dotnet", "WebApi.dll"]

