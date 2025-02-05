#!/bin/bash

# Ejecutar el primer script remoto de instalación
echo "Ejecutando script remoto de instalación (install_services.sh)..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/install_services.sh | bash

# Ejecutar el segundo script remoto de instalación (deploy_ssl_handler.sh)
echo "Ejecutando script remoto de instalación (deploy_ssl_handler.sh)..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/deploy_ssl_handler.sh | bash

# Clonar el repositorio en el directorio actual
echo "Clonando el repositorio..."
git clone https://github.com/daordonez/assesable-activity2-wad-2024-25.git

echo "Proceso completado con éxito."
