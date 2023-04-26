#!/bin/bash
# Autor: Marcus Mayorga

# Abre la carpeta minecraftbe
cd /home/ubuntu/minecraftbe

# Lista todas las carpetas dentro de minecraftbe
echo "Las carpetas dentro de minecraftbe son:"
carpetas=($(ls -d */))
for i in "${!carpetas[@]}"; do
    printf "%s\t%s\n" "$i" "${carpetas[$i]}"
done

# Pide al usuario que ingrese el número de la carpeta que desea eliminar
echo "Ingrese el número de la carpeta que desea eliminar:"
read num_carpeta

# Verifica si el número ingresado es válido
if [[ "$num_carpeta" =~ ^[0-9]+$ ]] && [ "$num_carpeta" -lt "${#carpetas[@]}" ]
then
    # Obtiene el nombre de la carpeta seleccionada
    carpeta="${carpetas[$num_carpeta]}"

    # Pide confirmación para eliminar la carpeta
    echo "¿Está seguro de que desea eliminar la carpeta $carpeta? (S/N)"
    read confirmacion

    if [ "$confirmacion" == "S" ]
    then
        # Elimina la carpeta
        rm -r "$carpeta"
        echo "La carpeta $carpeta ha sido eliminada."
    else
        echo "La carpeta no ha sido eliminada."
    fi
else
    echo "El número ingresado no es válido o está fuera del rango de opciones."
fi

# Lista las tareas de crontab -e
echo "Las siguientes tareas se encuentran en crontab -e:"
tareas=$(crontab -l)
echo "$tareas"

# Pide al usuario que ingrese el número de la tarea que desea eliminar
echo "Ingrese el número de la tarea que desea eliminar (0 para salir):"
read num_tarea

# Verifica si el número ingresado es válido
if [[ "$num_tarea" =~ ^[0-9]+$ ]] && [ "$num_tarea" -le "$(echo "$tareas" | wc -l)" ]
then
    if [ "$num_tarea" -eq 0 ]
    then
        echo "No se ha eliminado ninguna tarea."
    else
        # Obtiene la tarea seleccionada
        tarea=$(echo "$tareas" | sed "${num_tarea}q;d")

        # Pide confirmación para eliminar la tarea
        echo "¿Está seguro de que desea eliminar la tarea $tarea? (S/N)"
        read confirmacion

        if [ "$confirmacion" == "S" ]
        then
            # Elimina la tarea
            crontab -l | sed "${num_tarea}d" | crontab -
            echo "La tarea $tarea ha sido eliminada."
        else
            echo "La tarea no ha sido eliminada."
        fi
    fi
else
    echo "El número ingresado no es válido o está fuera del rango de opciones."
fi

# Pregunta al usuario si desea eliminar el script de backup.sh
echo "¿Desea eliminar el script de backup.sh? (S/N)"
read confirmacion

if [ "$confirmacion" == "S" ]
then
    # Elimina el script backup.sh
    rm /home/ubuntu/backup.sh
    echo "El script backup.sh ha sido eliminado."
else
    echo "El script backup.sh no ha sido eliminado."
fi

# Muestra un mensaje de que el servidor ha sido eliminado y sale del script
echo "*********************************************************************"
echo "SE COMPLETO LA ELIMINACIÓN DEL SERVIDOR SELECIONADO"
echo "*********************************************************************"
exit 0
