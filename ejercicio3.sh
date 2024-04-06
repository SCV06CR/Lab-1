#!/bin/bash
ayuda() {
    echo "Uso: $0 [-h HELP] [-m MODE] [-d DATE]"
    echo " -h imprime el menu de ayuda"
    echo " -m MODE: Modo de funcionamiento del informe (Ejemplo: servidor_web, base_de_datos, proceso_batch, aplicacion, monitoreo)"
    echo " -d DATE: Fecha en el formato year-month-day (ejemplo: 2024-03-08)"
}

gen_informe() {
    if [ -z "$modo" ] && [ -z "$fecha" ]; then
        echo "Debe especificar una opcion"
        exit 1
    fi

    fecha_act=""
    primera_fecha=true

    if [ -n "$modo" ] && [ -n "$fecha" ]; then
        echo "Generando informe para modo $modo con fecha $fecha:"
        grep "\[$modo\].*$fecha" *.log | grep "ERROR" | while read -r linea; do
            fecha=$(echo "$linea" | awk '{print $1}')
            if [ "$fecha_act" != "$fecha" ]; then
                if [ "$primera_fecha" = false ]; then
                    echo ""
                fi
                echo "Fecha: $fecha"
                fecha_act="$fecha"
                primera_fecha=false 
            fi
            echo "$linea" | awk '{print "Hora del Error:", $2, "\nDescripcion del Error:", substr($0, index($0,$6))}'
        done
    elif [ -n "$modo" ]; then
        echo "Generando informe para modo $modo:"
        grep "\[$modo\]" *.log | grep "ERROR" | while read -r linea; do
            fecha=$(echo "$linea" | awk '{print $1}')
            if [ "$fecha_act" != "$fecha" ]; then
                if [ "$primera_fecha" = false ]; then
                    echo ""
                fi
                echo "Fecha: $fecha"
                fecha_act="$fecha"
                primera_fecha=false 
            fi
            echo "$linea" | awk '{print "Hora del Error:", $2, "\nDescripcion del Error:", substr($0, index($0,$6))}'
        done
    else
        echo "Generando informe para la fecha $fecha:"
        grep "$fecha" *.log | grep "ERROR" | while read -r linea; do
            fecha=$(echo "$linea" | awk '{print $1}')
            if [ "$fecha_act" != "$fecha" ]; then
                if [ "$primera_fecha" = false ]; then
                    echo ""
                fi
                echo "Fecha: $fecha"
                fecha_act="$fecha"
                primera_fecha=false 
            fi
            echo "$linea" | awk '{print "Hora del Error:", $2, "\nDescripcion del Error:", substr($0, index($0,$6))}'
        done
    fi
}

while getopts ":hm:d:" opcion; do 
    case $opcion in 
        h)
            ayuda
            exit 0
            ;;
        m)
            modo=$OPTARG
            ;;
        d)
            fecha=$OPTARG
            ;;
        \?)
            echo "Opcion invalida: -$OPTARG. Use -h para ayuda" >&2
            exit 1
            ;;
        :)
            echo "La opcion -$OPTARG requiere argumento" >&2
            exit 1
            ;;
    esac 
done

gen_informe