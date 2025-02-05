#!/bin/bash

# Obtener la ruta del directorio donde se está ejecutando el script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Ejecutar el script remoto de instalación (install_services.sh)
echo "Ejecutando script remoto de instalación (install_services.sh)..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/install_services.sh | bash

# Verificar si el repositorio ya existe
REPO_DIR="$SCRIPT_DIR/assesable-activity2-wad-2024-25"
if [ -d "$REPO_DIR" ]; then
    echo "El repositorio ya existe. Actualizando con 'git pull'..."
    cd "$REPO_DIR" && git pull
else
    echo "Clonando el repositorio..."
    git clone https://github.com/daordonez/assesable-activity2-wad-2024-25.git
    cd "$REPO_DIR"
fi

# Mover a la ruta relativa scripts dentro del repositorio
cd "$REPO_DIR/scripts"

#Configurar servicios instalados
# Apache configuration
echo "Configurando Apache..."
sudo -E bash ./apache_setup.sh

# Ejecutar el script remoto de instalación (deploy_ssl_handler.sh)
echo "Ejecutando script de instalación (deploy_ssl_handler.sh)..."
sudo bash ./deploy_ssl_handler.sh


echo "Configurando aplicación React"
react_app="$REPO_DIR/app/web_server"
sudo bash "$react_app/react_app.sh" "$REPO_DIR"

echo "Proceso completado con éxito."
