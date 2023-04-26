#!/bin/bash

while true
do
# Variable que contiene el número de líneas que se van a revisar
lineas=5

# Variable que contiene el nombre del screen
screen="MarcusGamer"

# Comando que busca la cadena "Player Spawned" en las últimas $lineas del screen
if screen -S $screen -X stuff "tail -n $lineas logs/latest.log | grep 'Player Spawned'"$(printf \\r); then
  # Si se encontró la cadena, enviar el comando effect al jugador MarcusGamer8604
  screen -S $screen -X stuff "effect MarcusGamer8604 regeneration 60 3 true"$(printf \\r)
  # Enviar un mensaje
  screen -S $screen -X stuff "/tellraw @a {"rawtext":[{"text":"¡Bienvenido al servidor! Que disfrutes de tu tiempo aquí."}]} $(printf \\r)"
fi
sleep 30 # Espera 60 segundos antes de repetir el ciclo
done

#-------------------------------------------------------

#!/bin/bash

# Buscar las últimas 5 líneas del screen "MarcusGamer" en el archivo de registro
lines=$(tail -n 5 /path/to/marcusgamer/logs/latest.log | grep "Player Spawned MarcusGamer")

# Si se encuentra la palabra "Player Spawned" seguida del nombre del jugador
if [[ ! -z "$lines" ]]; then
    # Obtener el nombre del jugador de la línea que contiene "Player Spawned MarcusGamer"
    player=$(echo "$lines" | sed -n 's/.*Player Spawned \(.*\)/\1/p')
    # Mostrar un mensaje de bienvenida usando tellraw
    screen -S MarcusGamer -p 0 -X stuff "tellraw \"$player\" [{\"text\":\"¡Bienvenido al servidor!\"}]\r"
    # Enviar un comando personalizado
    screen -S MarcusGamer -p 0 -X stuff "effect \"$player\" regeneration 60 5 true\r"
fi




#-------------------------------------------------------


#!/bin/bash

while true
do
# Cambiar a la pantalla de Minecraft
screen -R Minecraft

# Buscar la última aparición de "Player Spawned" en las últimas 15 líneas
line=$(tail -n 15 /var/minecraft/server/logs/latest.log | grep -n "Player Spawned" | tail -1 | cut -d ':' -f 1)

# Si se encuentra la palabra, aplicar el efecto al jugador y enviar un mensaje
if [ -n "$line" ]; then
  player=$(tail -n $line /var/minecraft/server/logs/latest.log | grep "Player Spawned" | cut -d ' ' -f 8)
  echo "El jugador $player ha spawneado. Aplicando efecto..."
  screen -S Minecraft -p 0 -X stuff "effect $player regeneration 60 3 true\n"
  screen -S Minecraft -p 0 -X stuff "tellraw $player {\"text\":\"¡Bienvenido! Se te ha aplicado el efecto de regeneración.\"}\n"
else
  echo "No se ha detectado el spawn de ningún jugador en las últimas 15 líneas."
fi
sleep 60 # Espera 60 segundos antes de repetir el ciclo
done


#--------------------------------------------------------------------------


#!/bin/bash

# Nombre de la sesión de screen del servidor de Minecraft Bedrock
SCREEN_NAME="MarcusGamer"

# Palabra para detectar al jugador que se conectó en las últimas 15 líneas
PLAYER_PATTERN="Player Spawned"

# Obtiene el nombre del jugador de la línea encontrada
PLAYER_NAME=$(echo $PLAYER_LINE | sed 's/.*Player Spawned: //;s/ .*$//')

# Comando a ejecutar en el jugador detectado
PLAYER_COMMAND="effect $PLAYER_NAME regeneration 60 5 true"

# Mensaje a enviar al jugador detectado
PLAYER_MESSAGE="¡Bienvenido! Se te ha dado regeneración por 1 minuto."

# Busca la última ocurrencia de la palabra que identifica al jugador que se conectó
PLAYER_LINE=$(screen -S $SCREEN_NAME -X stuff $'\033[G'$(tail -n 15 $(screen -ls | grep $SCREEN_NAME | awk '{print $1}')/logs/latest.log | grep -i "$PLAYER_PATTERN" | tail -1)$'\n')

# Si se encontró el jugador, ejecuta el comando y envía el mensaje
if [ -n "$PLAYER_NAME" ]; then
  screen -S $SCREEN_NAME -X stuff $'\033[G'"/execute \"$PLAYER_NAME\" $PLAYER_COMMAND\n"
  screen -S $SCREEN_NAME -X stuff $'\033[G'"/tellraw \"$PLAYER_NAME\" {\"rawtext\":[{\"text\":\"$PLAYER_MESSAGE\"}]}\n"
fi
