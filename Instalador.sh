#!/bin/bash
# Autor: Marcus Mayorga

#-------------------------------------------------------------------------------------
# Script en desarrollo
# Este Script instala un servidor de Minecraft Bedrock dentro una instancia con Ubuntu
# curl https://raw.githubusercontent.com/Gamers-gq/Bedrock-Server/master/Instalador.sh | bash
#-------------------------------------------------------------------------------------


# 1. Actualizar e instalar dependencias
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y wget screen unzip

# 2. Establecer la hora y fecha
sudo timedatectl set-timezone America/Guayaquil

# 3. Crear directorio principal
sudo mkdir /mcbe

# 4. Preguntar el nombre del servidor y crear subdirectorio
read -p "Ingresa el nombre del servidor: " server_name
sudo mkdir /mcbe/$server_name

# 5. Descargar última versión de Minecraft Bedrock
cd /mcbe/$server_name
sudo wget -O bedrock-server.zip https://minecraft.net/en-us/download/server/bedrock
sudo unzip bedrock-server.zip
sudo chmod +x bedrock_server

# 6. Iniciar automáticamente en el inicio del sistema
echo "@reboot cd /mcbe/$server_name && ./start.sh" | crontab -

# 7. Programar reinicio y copia de seguridad
read -p "Ingresa la hora (en formato HH:MM) en la que se hará el reinicio diario: " restart_time
mkdir backups
echo "$restart_time * * * cd /mcbe/$server_name && ./stop.sh" | crontab -
echo "$restart_time * * * cd /mcbe/$server_name && cp -r world backups/world-$(date +%F-%H-%M-%S)" | crontab -

# 8. Configurar archivo server.properties
read -p "Ingresa el valor para max-players (valor predeterminado 10): " max_players
echo "max-players=$max_players" >> server.properties

# 9. Crear carpeta de registros
mkdir logs

# 10. Crear script start.sh
echo "#!/bin/bash
cd /mcbe/$server_name
screen -S $server_name -d -m ./bedrock_server" > start.sh
chmod +x start.sh

# 11. Crear script stop.sh
echo "#!/bin/bash
cd /mcbe/$server_name
screen -S $server_name -p 0 -X stuff 'stop\n'
sleep 10
cp -r world backups/world-$(date +%F-%H-%M-%S)" > stop.sh
chmod +x stop.sh

# 12. Crear script update.sh
echo "#!/bin/bash
cd /mcbe/$server_name
./stop.sh
wget -O bedrock-server.zip https://minecraft.net/en-us/download/server/bedrock
sudo unzip bedrock-server.zip
rm bedrock-server.zip
./start.sh" > update.sh
chmod +x update.sh

# Mensaje de finalización
echo "La instalación se ha completado exitosamente. Para ingresar a la pantalla del servidor, ejecuta el siguiente comando:"
echo "screen -r $server_name"
