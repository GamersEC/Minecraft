#!/bin/bash
#Autor: Marcus Mayorga
# Este Script crea una copia de seguridad de los mundos y las propiedades del servidor a una unidad remota de rclone
# Este Script requiere tener instalado zip para crear los archivos de backups
# Para que el script se ejecute cada 6 horas --> "0 */6 * * * /ruta/completa/al/archivo/backup.sh"

# Rutas de los archivos a respaldar
origen_carpeta="/home/ubuntu/minecraftbe/MarcusGamer/worlds"
origen_archivo1="/home/ubuntu/minecraftbe/MarcusGamer/server.properties"
origen_archivo2="/home/ubuntu/minecraftbe/MarcusGamer/allowlist.json"

# Ruta de la carpeta remota donde se creara el backup
destino="/home/ubuntu/Cloud/GamersEC/MarcusGamer"

# Nombre del archivo de respaldo
nombre_archivo="BAK_$(date +"%d-%m-%Y_%H-%M").zip"

# Crear la carpeta de destino si no existe
mkdir -p "$destino"

# Crear la copia de seguridad
tar czf "$destino/$nombre_archivo" -C "$(dirname "$origen_carpeta")" "$(basename "$origen_carpeta")" -C "$(dirname "$origen_archivo1")" "$(basename "$origen_archivo1")" -C "$(dirname "$origen_archivo2")" "$(basename "$origen_archivo2")"

# Comprobar si se ha creado correctamente la copia de seguridad
if [ -f "$destino/$nombre_archivo" ]; then
    echo "Copia de seguridad creada correctamente en $destino/$nombre_archivo"
else
    echo "Error al crear la copia de seguridad"
fi

# Verificar si hay más de 5 archivos de copia de seguridad y eliminar los más antiguos
cantidad_copias=$(ls -1 "$destino"/*.zip | wc -l)
if [ "$cantidad_copias" -gt 5 ]; then
  cantidad_eliminar=$(expr $cantidad_copias - 5)
  ls -1tr "$destino"/*.zip | head -n $cantidad_eliminar | xargs rm -f
fi