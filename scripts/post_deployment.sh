#!/bin/bash

# Ejecutar el script remoto de instalación (install_services.sh)
echo "Ejecutando script remoto de instalación (install_services.sh)..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/install_services.sh | bash

# Verificar si el repositorio ya existe
REPO_DIR="assesable-activity2-wad-2024-25"
if [ -d "$REPO_DIR" ]; then
    echo "El repositorio ya existe. Actualizando con 'git pull'..."
    cd "$REPO_DIR" && git pull
else
    echo "Clonando el repositorio..."
    git clone https://github.com/daordonez/assesable-activity2-wad-2024-25.git
    cd "$REPO_DIR"
fi

# Mover a la ruta /assesable-activity2-wad-2024-25/scripts
echo "Moviendo a la ruta /assesable-activity2-wad-2024-25/scripts..."
cd /assesable-activity2-wad-2024-25/scripts

# Ejecutar el script remoto de instalación (deploy_ssl_handler.sh)
echo "Ejecutando script remoto de instalación (deploy_ssl_handler.sh)..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/deploy_ssl_handler.sh | bash

echo "Proceso completado con éxito."
