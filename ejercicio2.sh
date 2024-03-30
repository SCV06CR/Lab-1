#!/bin/bash
nuevo_user="$1"
nuevo_group="$2"

error() {
    echo "$1">&2
}

if id "$nuevo_user" &>/dev/null; then
    error "El usuario \"$nuevo_user\" ya existe"
else
    sudo useradd "$nuevo_user" -m -s /bin/bash
    if [ $? -eq 0 ]; then
        echo "Usuario \"$nuevo_user\" ha sido creado"
    else
        error "Error al crear usuario"
    fi
fi

if grep -q "^$nuevo_group:" /etc/group; then
    echo "El grupo \"$nuevo_group\" ya existe"
else 
    sudo groupadd "$nuevo_group"
    if [ $? -eq 0 ]; then
        echo "Grupo \"$nuevo_group\" ha sido creado"
    else
        error "Error al crear grupo"
    fi
fi

sudo usermod -aG "$nuevo_group" "$USER"
sudo usermod -aG "$nuevo_group" "$nuevo_user"
sudo chgrp "$nuevo_group" ejercicio1.sh
sudo chmod g+x ejercicio1.sh 

echo "Permisos de ejecucion dados al grupo \"$nuevo_group\" para ejercicio1"