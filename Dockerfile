# Usa a imagem do SDK do .NET 7.0 para construir a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia todos os arquivos do diretório atual para o diretório de trabalho no contêiner
COPY . .

# Restaura as dependências especificadas no arquivo de projeto
RUN dotnet restore "API-Tempo.csproj"

# Publica a aplicação em modo Release para a pasta 'out'
RUN dotnet publish -c Release -o out

# Usa a imagem do runtime do .NET 7.0 para executar a aplicação
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos publicados do estágio de build para o diretório de trabalho no contêiner
COPY --from=build /app/out .

# Expõe a porta 8080 para acesso externo
EXPOSE 8080

# Expõe a porta 8081 para acesso externo
EXPOSE 8081

# Define o ponto de entrada do contêiner para executar a aplicação
ENTRYPOINT ["dotnet", "API-Tempo.dll"]