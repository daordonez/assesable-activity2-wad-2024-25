#!/bin/bash

# verify wheter if requried param is provided
if [ -z "$1" ]; then
  echo "Por favor, proporciona un path como parámetro."
  exit 1
fi

# Assign given param
base_path=$1
path_scripts="$base_path/scripts"


#Load admin conf .yaml
deployment_file="$path_scripts/00_deployment.yaml"
apache_app_path="/etc/apache2/sites-available"

APP_NAME=$(yq e '.app.name' $deployment_file)
APP_PORT=$(yq e '.app.port' $deployment_file)
APP_DOMAIN=$(yq e '.app.fqdn' $deployment_file)
APP_ADMIN=$(yq e '.app.admin' $deployment_file)
APP_DOCUMENT_ROOT=$(yq e '.app.document_root' $deployment_file)
#this defines the path: /var/www/html/app_name used by apache to serve the app (virtualdirectory)
DocumentRoot="$APP_DOCUMENT_ROOT/$APP_NAME"

####################################
#REACT APP BUILD & DEPLOYMENT
####################################
path_app="$1/app/$APP_NAME"

cd $path_app

echo "Instalando dependencias de la aplicación React..."
npm install

echo "Construyendo la aplicación React..."
npm run build

sudo cp -r "$path_app/dist" $DocumentRoot

####################################

#Generating apache virtual directory conf file
#it copies the content on: /etc/apache2/sites-available/file.conf
virtual_directory="$apache_app_path/$APP_NAME.conf"

####################################
# VIRTUAL DIRECTORY APP
####################################
echo -e "<VirtualHost *:$APP_PORT>
    
    ServerName $APP_DOMAIN
    ServerAdmin $APP_ADMIN
    DocumentRoot $DocumentRoot

    <Directory $DocumentRoot>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" | sudo tee $virtual_directory > /dev/null
####################################

cat $virtual_directory

#Enabling App port
echo "Listen $APP_PORT" | sudo tee -a /etc/apache2/ports.conf > /dev/null
#Enabling the virtual directory
sudo a2ensite "$APP_NAME.conf"
#Apache restart
sudo systemctl restart apache2

# Confirm apache restart
if systemctl is-active --quiet apache2; then
    echo "Apache se ha reiniciado correctamente."
    echo "Configuración de Apache completada"
else
    echo "Hubo un problema al reiniciar Apache."
    exit 1
fi

echo "Configurando aplicación React con pm2..."

#Enable pm2 to start on boot
if pm2 list | grep -q $APP_NAME; then
    echo "El proceso '$APP_NAME' ya está en ejecución. Reiniciando..."
    pm2 delete $APP_NAME
else
    echo "Iniciando el proceso '$APP_NAME'..."
fi

pm2 start "$DocumentRoot/index.html" --name $APP_NAME
pm2 startup
pm2 save
echo "Aplicación levantada con pm2"