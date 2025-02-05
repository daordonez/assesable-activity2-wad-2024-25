#!/bin/bash

# Actualizar lista de paquetes y actualizar sistema
echo "Actualizando sistema..."
sudo apt update -y && sudo apt upgrade -y

# Instalar Git
echo "Instalando Git..."
sudo apt install -y git

# Instalar Apache
echo "Instalando Apache..."
sudo apt install -y apache2

# Instalar Node.js y npm desde NodeSource
echo "Instalando Node.js y npm..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar PM2 globalmente
echo "Instalando PM2..."
sudo npm install -g pm2

# Verificar versiones instaladas
echo "\nVerificaciones:"
echo "Git: $(git --version)"
echo "Apache: $(apache2 -v | head -n 1)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "PM2: $(pm2 -v)"

echo "\nInstalación completada con éxito."