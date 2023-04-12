#!/bin/bash
# Autor: Marcus Mayorga

while true; do

# Proceso a verificar
minecraft="/home/ubuntu/minecraftbe/Personal/bedrock_server"

# Comprobar si el proceso está en ejecución
if pgrep -x "$minecraft" > /dev/null; then
  echo "El servidor de Minecraft Bedrock no está activo."
else
  # Si el proceso no está en ejecución, abrir la ubicación y ejecutar el comando
  ubicacion="/home/ubuntu/minecraftbe/Personal"
  comando="./start.sh"
  cd "$ubicacion" && "$comando"
echo "El servidor de Minecraft Bedrock está activo."
fi
sleep 90
done