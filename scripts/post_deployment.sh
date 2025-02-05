#!/bin/bash

# Ejecutar el script remoto de instalación
echo "Ejecutando script remoto de instalación..."
curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/scripts/install_services.sh | bash

# Clonar el repositorio en el directorio actual
echo "Clonando el repositorio..."
git clone https://github.com/daordonez/assesable-activity2-wad-2024-25.git

echo "Proceso completado con éxito."
