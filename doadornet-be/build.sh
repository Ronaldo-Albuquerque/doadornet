#!/bin/bash

# Parar e remover containers e volumes específicos do projeto
docker-compose down --volumes --remove-orphans

# Remover imagens do projeto 'doadornet'
docker images --filter "reference=doadornet*" -q | xargs -r docker rmi

# Remover containers do projeto 'doadornet'
docker ps -a --filter "name=doadornet" -q | xargs -r docker rm

# Subir novamente os containers com build e sem orphans
docker-compose up --build --remove-orphans




# docker exec -it doadornet-mysql mysql -u root -p