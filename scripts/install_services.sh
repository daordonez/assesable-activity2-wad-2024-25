#!/bin/bash

# test if a package is installed
test_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

# Update system
echo "Actualizando sistema..."
sudo apt update -y && sudo apt upgrade -y

# Install git if not installed
if ! test_installed git; then
    echo "Instalando Git..."
    sudo apt install -y git
else
    echo "Git ya está instalado. Versión: $(git --version)"
fi

# Install Apache if not installed
if ! test_installed apache2; then
    echo "Instalando Apache..."
    sudo apt install -y apache2
else
    echo "Apache ya está instalado. Versión: $(apache2 -v | head -n 1)"
fi

# Install PHP, libapache2-mod-php, and php-mysql if not installed
if ! test_installed php || ! test_installed libapache2-mod-php || ! test_installed php-mysql; then
    echo "Instalando PHP, libapache2-mod-php y php-mysql..."
    sudo apt install -y php libapache2-mod-php php-mysql
else
    echo "PHP, libapache2-mod-php y php-mysql ya están instalados."
    echo "PHP versión: $(php -v | head -n 1)"
fi

# Verify Node installation, install if not installed
NODE_VERSION="v22.0.0"
if ! command -v node &>/dev/null || [[ $(node -v) != "$NODE_VERSION" ]]; then
    echo "Instalando Node.js y npm..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js ya está instalado. Versión: $(node -v)"
fi

# Install PM2 if not installed
test_pm2_installed=$(npm list -g pm2 | grep pm2)
if [ -z "$test_pm2_installed" ]; then
    echo "Instalando PM2..."
    sudo npm install -g pm2
else
    echo "PM2 ya está instalado. Versión: $(pm2 -v)"
fi

# Install Docker if not installed
if ! command -v docker &>/dev/null; then
    echo "Instalando Docker..."
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker instalado correctamente. Ejecutando prueba..."
    sudo docker run hello-world
    sudo usermod -aG docker $USER
else
    echo "Docker ya está instalado. Versión: $(docker --version)"
fi

# Install yq if not installed
if ! command -v yq &>/dev/null; then
    echo "Instalando yq..."
    sudo apt update -y
    sudo apt install -y jq
    sudo wget https://github.com/mikefarah/yq/releases/download/v4.16.1/yq_linux_amd64 -O /usr/local/bin/yq
    sudo chmod +x /usr/local/bin/yq
else
    echo "yq ya está instalado. Versión: $(yq --version)"
fi

# Verify installation
echo "\nVerificaciones:"
echo "Git: $(git --version)"
echo "Apache: $(apache2 -v | head -n 1)"
echo "PHP: $(php -v | head -n 1)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "PM2: $(pm2 -v)"
echo "Docker: $(docker --version)"
echo "yq: $(yq --version)"

echo "Instalación completada con éxito."
