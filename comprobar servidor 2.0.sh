#!/bin/bash
# Autor: Marcus Mayorga

while true
do
   if pgrep /home/ubuntu/minecraftbe/MarcusGamer/bedrock_server > /dev/null
   then
       sleep 5
   else
       echo "Minecraft Server se ha detenido. Iniciando..."
       /home/ubuntu/minecraftbe/MarcusGamer/start.sh
   fi
   sleep 10
done