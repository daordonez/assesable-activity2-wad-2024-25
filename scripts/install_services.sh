#!/bin/bash

# Función para comprobar si un paquete está instalado
test_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

# Actualizar lista de paquetes y actualizar sistema
echo "Actualizando sistema..."
sudo apt update -y && sudo apt upgrade -y

# Instalar Git si no está instalado
if ! test_installed git; then
    echo "Instalando Git..."
    sudo apt install -y git
else
    echo "Git ya está instalado. Versión: $(git --version)"
fi

# Instalar Apache si no está instalado
if ! test_installed apache2; then
    echo "Instalando Apache..."
    sudo apt install -y apache2
else
    echo "Apache ya está instalado. Versión: $(apache2 -v | head -n 1)"
fi

# Instalar Node.js y npm si no están instalados o si la versión no es la correcta
NODE_VERSION="v22.0.0"
if ! command -v node &>/dev/null || [[ $(node -v) != "$NODE_VERSION" ]]; then
    echo "Instalando Node.js y npm..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js ya está instalado. Versión: $(node -v)"
fi

# Instalar PM2 si no está instalado
test_pm2_installed=$(npm list -g pm2 | grep pm2)
if [ -z "$test_pm2_installed" ]; then
    echo "Instalando PM2..."
    sudo npm install -g pm2
else
    echo "PM2 ya está instalado. Versión: $(pm2 -v)"
fi

# Instalar Docker si no está instalado
if ! command -v docker &>/dev/null; then
    echo "Instalando Docker..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker instalado correctamente. Ejecutando prueba..."
    sudo docker run hello-world
else
    echo "Docker ya está instalado. Versión: $(docker --version)"
fi

# Verificar versiones instaladas
echo "\nVerificaciones:"
echo "Git: $(git --version)"
echo "Apache: $(apache2 -v | head -n 1)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "PM2: $(pm2 -v)"
echo "Docker: $(docker --version)"

echo "Instalación completada con éxito."