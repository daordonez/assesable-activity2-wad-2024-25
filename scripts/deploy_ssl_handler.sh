#!/bin/bash

#Proxy configuration
PROXY_NAME=$(yq e '.proxy.name' $deployment_file)
PROXY_NET=$(yq e '.proxy.network' $deployment_file)
PROXY_WEB_PORT=$(yq e '.proxy.port_web' $deployment_file)
PROXY_SSL_PORT=$(yq e '.proxy.port_ssl' $deployment_file)
PROXY_ADM_PORT=$(yq e '.proxy.port_admin' $deployment_file)

# Verificar que Docker está instalado
if ! command -v docker &>/dev/null; then
    echo "Docker no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# Verificar que las variables de entorno están definidas
if [[ -z "$PROXY_NET" || -z "$PROXY_NAME" ]]; then
    echo "Las variables PROXY_NET y PROXY_NAME deben estar definidas."
    exit 1
fi

# Crear la red si no existe
if ! sudo docker network ls | grep -q "$PROXY_NET"; then
    echo "Creando la red $PROXY_NET..."
    sudo docker network create "$PROXY_NET"
fi

# Verificar si el contenedor ya está en ejecución
if sudo docker ps --format '{{.Names}}' | grep -q "^$PROXY_NAME$"; then
    echo "El contenedor $PROXY_NAME ya está en ejecución."
    exit 0
fi

# Si el contenedor existe pero está detenido, eliminarlo
if sudo docker ps -a --format '{{.Names}}' | grep -q "^$PROXY_NAME$"; then
    echo "Eliminando contenedor detenido $PROXY_NAME..."
    sudo docker rm "$PROXY_NAME"
fi

# Ejecutar el contenedor de Nginx Proxy Manager
sudo docker run -d \
    --name "$PROXY_NAME" \
    --network "$PROXY_NET" \
    -p 80:80 -p 81:81 -p 443:443 \
    -v npm_data:/data \
    -v npm_letsencrypt:/etc/letsencrypt \
    --restart unless-stopped \
    jc21/nginx-proxy-manager:latest

echo "El contenedor $PROXY_NAME ha sido iniciado correctamente."