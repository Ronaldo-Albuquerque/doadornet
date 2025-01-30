# Usar a imagem do Maven para compilar o projeto
FROM maven:3.8.4-openjdk-17 AS build

# Definir o diretório de trabalho dentro do container
WORKDIR /app

# Copiar o arquivo pom.xml e baixar as dependências do Maven
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar o código-fonte do projeto
COPY src /app/src

RUN rm -rf /app/target/*
# Construir o projeto e gerar o jar
RUN mvn clean install -U
RUN mvn clean package -DskipTests

RUN ls -l /app/target

# Usar a imagem do OpenJDK para rodar a aplicação
FROM openjdk:17-slim


RUN export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Definir o diretório de trabalho para a aplicação
WORKDIR /app

# Copiar o jar gerado no estágio de build para o container
COPY --from=build /app/target/doadornet-be-*.jar /app/doadornet-be.jar

# Definir a porta que a aplicação vai expor
EXPOSE 8080

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "/app/doadornet-be.jar"]
