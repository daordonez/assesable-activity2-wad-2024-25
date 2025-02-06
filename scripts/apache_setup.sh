#!/bin/bash

deployment_file="00_deployment.yaml"

#Apache variables
APACHE_PORT_WEB=$(yq e '.apache.port_web' $deployment_file)
APACHE_PORT_SSL=$(yq e '.apache.port_ssl' $deployment_file)


# Modify default Apache ports to allow port deployment based
echo -e "# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen $APACHE_PORT_WEB

<IfModule ssl_module>
Listen $APACHE_PORT_SSL
</IfModule>

<IfModule mod_gnutls.c>
Listen $APACHE_PORT_SSL
</IfModule>
" | sudo tee /etc/apache2/ports.conf > /dev/null


cat /etc/apache2/ports.conf

# Verify wheter the ports have been set
echo "El archivo ports.conf ha sido generado con los puertos $APACHE_PORT_WEB y $APACHE_PORT_SSL"

# Restart apache to apply the new configuration
echo "Reiniciando Apache para aplicar la nueva configuración..."
sudo systemctl restart apache2

# Confirm that Apache has been restarted
if systemctl is-active --quiet apache2; then
    echo "Apache se ha reiniciado correctamente."
else
    echo "Hubo un problema al reiniciar Apache."
    exit 1
fi
