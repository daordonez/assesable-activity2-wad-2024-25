#!/bin/bash


# Crear el archivo ports.conf con los valores del .env
cat <<EOL > /tmp/ports.conf
# If you just change the port or add more ports here...

Listen $APACHE_PORT_WEB

<IfModule ssl_module>
        Listen $APACHE_PORT_SSL
</IfModule>

<IfModule mod_gnutls.c>
        Listen $APACHE_PORT_SSL
</IfModule>
EOL

sudo mv /tmp/ports.conf /etc/apache2/ports.conf


cat /etc/apache2/ports.conf

# Verifica que el archivo ha sido generado correctamente
echo "El archivo ports.conf ha sido generado con los puertos $APACHE_PORT_WEB y $APACHE_PORT_SSL"

# Reiniciar Apache para aplicar los cambios
echo "Reiniciando Apache para aplicar la nueva configuración..."
sudo systemctl restart apache2

# Confirmar que Apache ha sido reiniciado
if systemctl is-active --quiet apache2; then
    echo "Apache se ha reiniciado correctamente."
else
    echo "Hubo un problema al reiniciar Apache."
    exit 1
fi
