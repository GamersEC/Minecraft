#!/bin/bash
# Autor: Marcus Mayorga

#-------------------------------------------------------------------------------------
# Este Script instala un servidor de Minecraft Bedrock dentro una instancia con Ubuntu
#-------------------------------------------------------------------------------------

# Instalar dependencias
sudo apt-get update
sudo apt-get install -y screen unzip wget

# Preguntar el nombre del servidor
read -p "Introduce el nombre del servidor: " server_name

# Crear el directorio del servidor y acceder a él
mkdir $server_name
cd $server_name

# Descargar la última versión de Minecraft Bedrock Server
latest_url=$(wget -q -O - "https://www.minecraft.net/en-us/download/server/bedrock/" | grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | head -1)
wget -q -O bedrock-server.zip $latest_url
unzip -q bedrock-server.zip

# Preguntar los puertos a usar
read -p "Introduce el puerto del servidor (19132 por defecto): " server_port
if [ -z "$server_port" ]; then
    server_port=19132
fi

read -p "Introduce el puerto RCON (19132 por defecto): " rcon_port
if [ -z "$rcon_port" ]; then
    rcon_port=19132
fi

# Preguntar las configuraciones del server.properties y guardarlas
echo "Introduce las siguientes configuraciones del server.properties:"

read -p "Gamemode (0,1,2,3): " gamemode
read -p "Difficulty (0,1,2,3): " difficulty
read -p "Max players (1-100): " max_players
read -p "Spawn protection (0-16): " spawn_protection
read -p "Allow Cheats (true/false): " allow_cheats
read -p "Player Idle Timeout (mins): " player_idle_timeout
read -p "View Distance (6-48): " view_distance

cat > server.properties <<EOL
server-name=$server_name
server-port=$server_port
max-players=$max_players
gamemode=$gamemode
difficulty=$difficulty
spawn-protection=$spawn_protection
allow-cheats=$allow_cheats
player-idle-timeout=$player_idle_timeout
view-distance=$view_distance
EOL

# Preguntar hora de reinicio y programarlo
read -p "Introduce la hora en formato HH:MM (por defecto: 04:00): " backup_time
if [ -z "$backup_time" ]; then
    backup_time="04:00"
fi

echo "Programando reinicio y copia de seguridad diaria a las $backup_time..."
(crontab -l ; echo "0 $backup_time * * * /bin/bash /path/to/backup_script.sh") | crontab -

# Esperar 30 segundos antes de iniciar el servidor
echo "Esperando 30 segundos antes de iniciar el servidor..."
sleep 30

# Iniciar el servidor
screen -S $server_name -d -m ./bedrock_server
echo "Servidor iniciado en segundo plano. Para ver la pantalla del servidor, ejecuta el comando 'screen -r $server_name'"