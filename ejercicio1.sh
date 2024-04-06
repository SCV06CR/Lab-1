
#!/bin/bash
error() {
    echo "$1" >&2
    exit 1
}

file="$1"
if [ ! -e "$file" ]; then
    error "el archivo \"$file\" no existe"
fi

permissions=$(stat -c "%A" "$file")

get_permissions_verbose() {
    local perms=$1
    user_perms=${perms:1:3}
    group_perms=${perms:4:3}
    other_perms=${perms:7:3}    

    inter_perm() {
        local perms=$1
        local type=$2

        for ((i=0; i<${#perms}; i++)); do
            perm=${perms:$i:1}
            case $perm in
                "r")
                    echo -n "$type tiene permiso de lectura "
                    ;;
                "w")
                    echo -n "$type tiene permiso de escritura "
                    ;;
                "x") 
                    echo -n "$type tiene permiso de ejecucion "
                    ;;
                "*")
                    echo -n "$type no tiene permiso de $perm "
                    ;;
            esac 
        done
    }

    echo "Permisos del usuario: "
    inter_perm "$user_perms" "usuario"
    echo ""

    echo "Permisos del grupo: "
    inter_perm "$group_perms" "grupo"
    echo ""

    echo "Permisos de otros: "
    inter_perm "$other_perms" "otros"
    echo ""
}

get_permissions_verbose "$permissions"