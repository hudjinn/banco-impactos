FROM postgis/postgis:13-3.1

# Crie o diretório onde o arquivo SQL será copiado
RUN mkdir -p /docker-entrypoint-initdb.d/

# Copie o arquivo SQL para o diretório de inicialização do banco de dados
COPY sql/monitor.sql /docker-entrypoint-initdb.d/

# Exponha a porta padrão do PostgreSQL
EXPOSE 5432

# Defina variáveis de ambiente para o PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=12345

# Inicie o PostgreSQL como o comando padrão
CMD ["postgres"]
