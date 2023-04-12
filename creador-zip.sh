#!/bin/bash
# Autor: Marcus Mayorga
# Este script requiere tener instalado zip, en caso de no tenerlo ejecute el siguiente comando --> sudo apt-get install zip


# Preguntar la ubicación de la carpeta a comprimir
read -p "Ingrese la ubicación de la carpeta que desea comprimir en zip: " ubicacion_carpeta

# Preguntar la ubicación donde guardar el archivo comprimido
read -p "Ingrese la ubicación donde desea guardar el archivo comprimido: " ubicacion_archivo

# Obtener el nombre de la carpeta final
nombre_carpeta="$(basename "$ubicacion_carpeta")"

# Preguntar si desea cambiar el nombre del archivo zip o dejar el nombre por defecto de la carpeta
read -p "Desea cambiar el nombre del archivo zip? (s/n) " respuesta

if [ "$respuesta" = "s" ]; then
  read -p "Ingrese el nombre que desea para el archivo zip: " nombre_archivo
else
  nombre_archivo="$nombre_carpeta"
fi

# Crear el archivo zip solo con la carpeta final
cd "$(dirname "$ubicacion_carpeta")" && zip -r "$ubicacion_archivo/$nombre_archivo.zip" "$nombre_carpeta"

echo "La carpeta $nombre_carpeta ha sido comprimida en $ubicacion_archivo/$nombre_archivo.zip"