#!/bin/bash

# Verificar si se ha proporcionado un argumento
if [ -z "$1" ]; then
  echo "Por favor, proporciona un path como parámetro."
  exit 1
fi

# Asignar el parámetro al path
base_path=$1
path_scripts="$base_path/scripts"


#cargar variables desde el archivo .yaml
deployment_file="$path_scripts/00_deployment.yaml"
apache_app_path="/etc/apache2/sites-available"

APP_NAME=$(yq e '.app.name' $deployment_file)
APP_PORT=$(yq e '.app.port' $deployment_file)
APP_DOMAIN=$(yq e '.app.fqdn' $deployment_file)
APP_ADMIN=$(yq e '.app.admin' $deployment_file)
APP_DOCUMENT_ROOT=$(yq e '.app.document_root' $deployment_file)
#this defines the path: /var/www/html/app_name used by apache to serve the app (virtualdirectory)
DocumentRoot="$APP_DOCUMENT_ROOT/$APP_NAME/"


#REACT APP

path_app="$1/app/$APP_NAME"

cd $path_app

echo "Instalando dependencias de la aplicación React..."
npm install

echo "Construyendo la aplicación React..."
npm run build

sudo cp -r "$path_app/build" $DocumentRoot

################

#generar fichero de configuración de apache
#it copies the content on: /etc/apache2/sites-available/file.conf
virtual_directory="$apache_app_path/$APP_NAME.conf"

####################################
# VIRTUAL DIRECTORY APP
####################################
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
</VirtualHost>" | sudo tee $virtual_directory > /dev/null
####################################

cat $virtual_directory

#Reiniciar apache
sudo systemctl restart apache2

# Confirmar que Apache ha sido reiniciado
if systemctl is-active --quiet apache2; then
    echo "Apache se ha reiniciado correctamente."
else
    echo "Hubo un problema al reiniciar Apache."
    exit 1
fi