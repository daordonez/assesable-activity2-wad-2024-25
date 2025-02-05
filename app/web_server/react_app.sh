#!/bin/bash

# Verificar si se ha proporcionado un argumento
if [ -z "$1" ]; then
  echo "Por favor, proporciona un path como parámetro."
  exit 1
fi

# Asignar el parámetro al path
path=$1

#cargar variables desde el archivo .yaml
deployment_file="$path/00_deployment.yaml"
apache_app_path="/etc/apache2/sites-available"

APP_NAME=$(yq e '.app.name' $deployment_file)
APP_PORT=$(yq e '.app.port' $deployment_file)
APP_DOMAIN=$(yq e '.app.fqdn' $deployment_file)
APP_ADMIN=$(yq e '.app.admin' $deployment_file)
APP_DOCUMENT_ROOT=$(yq e '.app.document_root' $deployment_file)
DocumentRoot="$APP_DOCUMENT_ROOT/$APP_NAME"

#generar fichero de configuración de apache
virtual_directory="$apache_app_path/$APP_NAME.conf"

echo -e "VirtualHost *:$APP_PORT>
    ServerAdmin $APP_ADMIN
    DocumentRoot $DocumentRoot

    <Directory $DocumentRoot>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" 

#| sudo tee $virtual_directory > /dev/null


#Reiniciar apache