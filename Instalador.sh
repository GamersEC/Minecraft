#!/bin/bash
# Autor: Marcus Mayorga

#-------------------------------------------------------------------------------------
# Este Script instala un servidor de Minecraft Bedrock dentro una instancia con Ubuntu
# curl https://raw.githubusercontent.com/Gamers-gq/Bedrock-Server/master/Instalador.sh | bash
#-------------------------------------------------------------------------------------


# Comprobar si el usuario es root
if [ "$EUID" -ne 0 ]
  then echo "Por favor, ejecute el script como root"
  exit
fi

# Comprobar y actualizar el sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias
sudo apt-get install -y curl screen unzip

# Establecer la hora y fecha según la zona America/Guayaquil
sudo timedatectl set-timezone America/Guayaquil

# Crear un directorio principal llamado "mcbe"
sudo mkdir /mcbe
sudo chown $USER:$USER /mcbe

# Preguntar el nombre del servidor y crear un subdirectorio con el mismo nombre
echo "Ingrese el nombre del servidor:"
read SERVER_NAME

sudo mkdir /mcbe/$SERVER_NAME

# Comprobar y descargar la última versión del servidor de Minecraft Bedrock
LATEST_VERSION=$(curl -s https://www.minecraft.net/en-us/download/server/bedrock/ | grep -oP 'https://minecraft.azureedge.net/bin-linux/[^"]+')

sudo curl -SL $LATEST_VERSION -o /mcbe/$SERVER_NAME/server.zip
sudo unzip /mcbe/$SERVER_NAME/server.zip -d /mcbe/$SERVER_NAME/
sudo rm /mcbe/$SERVER_NAME/server.zip

# Crear archivo de inicio del servicio
cat <<EOF | sudo tee /etc/systemd/system/minecraft-bedrock.service
[Unit]
Description=Minecraft Bedrock Server
After=network.target

[Service]
User=$USER
WorkingDirectory=/mcbe/$SERVER_NAME
ExecStart=/bin/bash /mcbe/$SERVER_NAME/start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Habilitar el servicio y reiniciar systemd
sudo systemctl daemon-reload
sudo systemctl enable minecraft-bedrock
sudo systemctl restart minecraft-bedrock

# Preguntar la hora de los reinicios automáticos
echo "Ingrese la hora de los reinicios automáticos en formato HH:MM:"
read RESTART_TIME

# Crear script de reinicio automático
cat <<EOF | sudo tee /mcbe/$SERVER_NAME/restart.sh
#!/bin/bash
sudo mkdir -p /mcbe/$SERVER_NAME/backups/
sudo zip -r /mcbe/$SERVER_NAME/backups/\$(date +'%Y-%m-%d_%H-%M-%S').zip /mcbe/$SERVER

# Preguntar las configuraciones del archivo server.properties
echo "Ingrese el nombre del mundo:"
read LEVEL_NAME

echo "Ingrese el número máximo de jugadores:"
read MAX_PLAYERS

echo "Ingrese la dificultad del mundo (0: Peaceful, 1: Easy, 2: Normal, 3: Hard):"
read DIFFICULTY

echo "Ingrese el modo de juego (0: survival, 1: creative, 2: adventure):"
read GAME_MODE

# Configurar el archivo server.properties
cat <<EOF | sudo tee /mcbe/$SERVER_NAME/server.properties
server-name=$SERVER_NAME
gamemode=$GAME_MODE
difficulty=$DIFFICULTY
max-players=$MAX_PLAYERS
level-name=$LEVEL_NAME
allow-cheats=false
enable-query=false
enable-rcon=false
rcon.password=
server-port=19132
texturepack-required=false
EOF

# Crear un registro con marcas de tiempo y guardarlas en una carpeta llamada "logs"
sudo mkdir /mcbe/$SERVER_NAME/logs
cat <<EOF | sudo tee /mcbe/$SERVER_NAME/start.sh
#!/bin/bash
cd /mcbe/$SERVER_NAME/
echo "[$(date)] Iniciando servidor..." >> logs/server.log
LD_LIBRARY_PATH=. ./bedrock_server >> logs/server.log
EOF

# Crear script para detener el servidor
cat <<EOF | sudo tee /mcbe/$SERVER_NAME/stop.sh
#!/bin/bash
cd /mcbe/$SERVER_NAME/
echo "[$(date)] Deteniendo servidor..." >> logs/server.log
screen -S $SERVER_NAME -X stuff "stop^M"
sleep 10s
sudo zip -r /mcbe/$SERVER_NAME/backups/\$(date +'%Y-%m-%d_%H-%M-%S').zip /mcbe/$SERVER_NAME/
EOF

# Crear script para actualizar el servidor
cat <<EOF | sudo tee /mcbe/$SERVER_NAME/update.sh
#!/bin/bash
cd /mcbe/$SERVER_NAME/
echo "[$(date)] Deteniendo servidor..." >> logs/server.log
screen -S $SERVER_NAME -X stuff "stop^M"
sleep 10s
sudo zip -r /mcbe/$SERVER_NAME/backups/\$(date +'%Y-%m-%d_%H-%M-%S').zip /mcbe/$SERVER_NAME/