#!/bin/bash

# Función para listar los primeros 25 procesos en ejecución
listar_procesos() {
    echo "Listando los primeros 25 procesos en ejecución..."
    ps aux | head -n 25
    read -p "Presione Enter para volver al menú de monitorización de procesos..."
    menu_monitorizacion_procesos
}

# Función para mostrar información detallada de un proceso específico
informacion_proceso() {
    read -p "Ingrese el PID del proceso: " pid
    if [ -z "$pid" ]; then
        echo "PID no proporcionado. Volviendo al menú de monitorización de procesos..."
        menu_monitorizacion_procesos
        return
    fi
    echo "Mostrando información del proceso con PID $pid..."
    ps -p $pid -o pid,ppid,cmd,%mem,%cpu
    read -p "Presione Enter para volver al menú de monitorización de procesos..."
    menu_monitorizacion_procesos
}

# Función para guardar la información de los procesos en un archivo de registro
guardar_log() {
    log_file="log_procesos.txt"
    echo "Guardando información de los procesos en $log_file..."
    ps aux > $log_file
    read -p "Presione Enter para volver al menú de monitorización de procesos..."
    menu_monitorizacion_procesos
}

# Función para listar los primeros 25 procesos que usan memoria, CPU 
listar_procesos_recursos() {
    echo "Listando los primeros 25 procesos que usan memoria, CPU..."
    ps aux --sort=-%mem,-%cpu | head -n 25
    read -p "Presione Enter para volver al menú de monitorización de procesos..."
    menu_monitorizacion_procesos
}

# Función para recargar systemd daemon
recargar_daemon() {
    sudo systemctl daemon-reload
}

# Función para listar los primeros 15 servicios
listar_servicios() {
    echo "Listando los primeros 15 servicios..."
    systemctl list-unit-files --type=service | head -n 16
}

# Función para mostrar el estado de un servicio
mostrar_estado_servicio() {
    local servicio=$1
    echo "Estado del servicio $servicio:"
    systemctl status $servicio
}

# Función para iniciar un servicio
iniciar_servicio() {
    read -p "Ingrese el nombre del servicio a iniciar: " servicio
    if systemctl list-unit-files --type=service | grep -q "^${servicio}.service"; then
        recargar_daemon
        echo "Iniciando el servicio $servicio..."
        sudo systemctl start $servicio
        mostrar_estado_servicio $servicio
    else
        echo "El servicio $servicio no se encuentra."
    fi
    read -p "Presione Enter para volver al menú de gestión de procesos..."
    menu_gestion_procesos
}

# Función para detener un servicio
detener_servicio() {
    read -p "Ingrese el nombre del servicio a detener: " servicio
    if systemctl list-unit-files --type=service | grep -q "^${servicio}.service"; then
        recargar_daemon
        echo "Deteniendo el servicio $servicio..."
        sudo systemctl stop $servicio
        mostrar_estado_servicio $servicio
    else
        echo "El servicio $servicio no se encuentra."
    fi
    read -p "Presione Enter para volver al menú de gestión de procesos..."
    menu_gestion_procesos
}

# Función para reiniciar un servicio
reiniciar_servicio() {
    read -p "Ingrese el nombre del servicio a reiniciar: " servicio
    if systemctl list-unit-files --type=service | grep -q "^${servicio}.service"; then
        recargar_daemon
        echo "Reiniciando el servicio $servicio..."
        sudo systemctl restart $servicio
        mostrar_estado_servicio $servicio
    else
        echo "El servicio $servicio no se encuentra."
    fi
    read -p "Presione Enter para volver al menú de gestión de procesos..."
    menu_gestion_procesos
}

# Función para cambiar el estado de habilitación de un servicio
cambiar_estado_servicio() {
    read -p "Ingrese el nombre del servicio para cambiar su estado: " servicio
    if systemctl list-unit-files --type=service | grep -q "^${servicio}.service"; then
        echo "Estados disponibles para cambiar: enabled, disabled"
        read -p "Ingrese el nuevo estado para el servicio (enabled, disabled): " nuevo_estado

        # Verificar si el estado ingresado es válido
        if [[ "$nuevo_estado" != "enabled" && "$nuevo_estado" != "disabled" ]]; then
            echo "Estado no válido. Debe ser enabled o disabled."
            menu_gestion_procesos
            return
        fi

        # Cambiar el estado del servicio
        if [ "$nuevo_estado" == "enabled" ]; then
            echo "Habilitando el servicio $servicio..."
            sudo systemctl enable $servicio
        elif [ "$nuevo_estado" == "disabled" ]; then
            echo "Deshabilitando el servicio $servicio..."
            sudo systemctl disable $servicio
        fi

        # Mostrar el estado actual del servicio
        mostrar_estado_servicio $servicio
        read -p "Presione Enter para volver al menú de gestión de procesos..."
        menu_gestion_procesos
    else
        echo "El servicio $servicio no se encuentra."
        read -p "Presione Enter para volver al menú de gestión de procesos..."
        menu_gestion_procesos
    fi
}

# Función para iniciar el analizador de procesos
iniciar_analizador() {
    echo "Iniciando el analizador de procesos..."
    while true; do
        proceso=$(ps aux --sort=-%mem,-%cpu | awk 'NR==2{print $2}')
        uso_cpu=$(ps -p $proceso -o %cpu=)
        uso_mem=$(ps -p $proceso -o %mem=)

        if (( $(echo "$uso_cpu > 15.0" | bc -l) )) || (( $(echo "$uso_mem > 1.0" | bc -l) )); then
            echo "Advertencia: El proceso con PID $proceso está utilizando demasiados recursos (CPU: $uso_cpu%, MEM: $uso_mem%)"
            gnome-terminal -- bash -c "echo 'Advertencia: El proceso con PID $proceso está utilizando demasiados recursos (CPU: $uso_cpu%, MEM: $uso_mem%)'; exec bash"
        fi
        sleep 5
    done &
    ANALYZER_PID=$!
    echo "Analizador de procesos iniciado con PID $ANALYZER_PID"
    read -p "Presione Enter para volver al menú del analizador de procesos..."
    menu_analizador_procesos
}

# Función para detener el analizador de procesos
detener_analizador() {
    if [ -n "$ANALYZER_PID" ]; then
        echo "Deteniendo el analizador de procesos con PID $ANALYZER_PID..."
        kill $ANALYZER_PID
        unset ANALYZER_PID
        echo "Analizador de procesos detenido."
    else
        echo "El analizador de procesos no está en ejecución."
    fi
    read -p "Presione Enter para volver al menú del analizador de procesos..."
    menu_analizador_procesos
}

# Función para crear un intervalo del script mediante cron
crear_intervalo() {
    read -p "Ingrese el intervalo de tiempo en minutos para cerrar automáticamente el script: " intervalo
    (crontab -l 2>/dev/null; echo "*/$intervalo * * * * pkill -f $(basename $0)") | crontab -
    echo "Intervalo creado. El script se cerrará automáticamente cada $intervalo minutos."
    read -p "Presione Enter para volver al menú de programación de tareas..."
    menu_programacion_tareas
}

# Función para eliminar el intervalo del script mediante cron
eliminar_intervalo() {
    crontab -l | grep -v "pkill -f $(basename $0)" | crontab -
    echo "Intervalo eliminado."
    read -p "Presione Enter para volver al menú de programación de tareas..."
    menu_programacion_tareas
}

# Menú de Programación de Tareas
menu_programacion_tareas() {
    clear
    echo "Seleccione una opción para la Asignacion del intervalo:"
    echo "1. Crear intervalo del script"
    echo "2. Eliminar intervalo del script"
    echo "3. Volver al menú principal"
    read -p "Opción: " opcion
    case $opcion in
        1) crear_intervalo ;;
        2) eliminar_intervalo ;;
        3) menu_principal ;;
        *) echo "Opción no válida"; menu_programacion_tareas ;;
    esac
}

# Menú de Analizador de Procesos
menu_analizador_procesos() {
    clear
    echo "Seleccione una opción para el Analizador de Procesos:"
    echo "1. Iniciar el analizador"
    echo "2. Detener el analizador"
    echo "3. Volver al menú principal"
    read -p "Opción: " opcion
    case $opcion in
        1) iniciar_analizador ;;
        2) detener_analizador ;;
        3) menu_principal ;;
        *) echo "Opción no válida"; menu_analizador_procesos ;;
    esac
}

# Menú de Monitorización de procesos
menu_monitorizacion_procesos() {
    clear
    echo "Seleccione una opción para Monitorización de Procesos:"
    echo "1. Lista de procesos en ejecución"
    echo "2. Lista de procesos en ejecución que están utilizando CPU o Memoria"
    echo "3. Búsqueda de un proceso específico por el PID"
    echo "4. Descargar en un archivo la lista de los procesos en ejecución"
    echo "5. Volver al menú anterior"
    read -p "Opción: " opcion
    case $opcion in
        1) listar_procesos ;;
        2) listar_procesos_recursos ;;
        3) informacion_proceso ;;
        4) guardar_log ;;
        5) menu_principal ;;
        *) echo "Opción no válida"; menu_monitorizacion_procesos ;;
    esac
}

# Menú de Gestión de Procesos
menu_gestion_procesos() {
    clear
    listar_servicios
    echo "Seleccione una opción para Gestión de Procesos:"
    echo "1. Iniciar un servicio"
    echo "2. Detener un servicio"
    echo "3. Reiniciar un servicio"
    echo "4. Cambiar el estado de un servicio"
    echo "5. Volver al menú anterior"
    read -p "Opción: " opcion
    case $opcion in
        1) iniciar_servicio ;;
        2) detener_servicio ;;
        3) reiniciar_servicio ;;
        4) cambiar_estado_servicio ;;
        5) menu_principal ;;
        *) echo "Opción no válida"; menu_gestion_procesos ;;
    esac
}

# Menú Principal
menu_principal() {
    clear
    echo "Seleccione una opción:"
    echo "1. Monitorización de procesos"
    echo "2. Gestión de procesos"
    echo "3. Asignador de intervalo del script"
    echo "4. Analizador de procesos"
    echo "5. Salir"
    read -p "Opción: " opcion
    case $opcion in
        1) menu_monitorizacion_procesos ;;
        2) menu_gestion_procesos ;;
        3) menu_programacion_tareas ;;
        4) menu_analizador_procesos ;;
        5) exit 0 ;;
        *) echo "Opción no válida"; menu_principal ;;
    esac
}

# Ejecutar menú principal
menu_principal
