#!/bin/bash

# Colores para identificar textos
COLOR_WELL='\033[1;32m'    # Verde brillante para éxito
COLOR_ERROR='\033[1;31m'   # Rojo brillante para error
COLOR_RESET='\033[0m'      # Reset de color

# Función para imprimir mensajes de estado exitosos
print_message() {
    echo -e "${COLOR_WELL}$1${COLOR_RESET}"
}

# Función para imprimir mensajes de error
print_error() {
    echo -e "${COLOR_ERROR}$1${COLOR_RESET}" >&2
}

# Función para realizar actualizaciones del sistema
run_checkpoint() {
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
}

# Función para recargar el entorno de bash
reload_env() {
    . ~/.bashrc
}

# Función para ejecutar un script de instalación y recargar el entorno
run_setup_script() {
    # Asigna nombres descriptivos a los parámetros
    local script_name="$1"  # Nombre del proceso de instalación (por ejemplo, "Homebrew")

    # Imprime el mensaje de inicio de instalación
    print_message "Instalando ${script_name}..."

    # Da permisos de ejecución al script
    chmod +x "$script_name"
        
    # Ejecuta el script en el entorno actual
    ./"$script_name"
        
    # Verifica si el script se ejecutó exitosamente
    if [[ $? -eq 0 ]]; then
        print_message "${script_name} se instaló correctamente."
    else
        print_error "Error al ejecutar ${script_name}."
        exit 1
    fi

    # Recarga el entorno para aplicar posibles cambios en el PATH
    reload_env
}


# Crear carpeta para archivos AppImage, si no existe
mkdir -p ~/Apps

# Obtener la ruta de descargas, con fallback
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Descargas")

main (){
    print_message "Permisos de Super Usuario requeridos..!"
    su -v || { print_error "Setup cancelado."; exit 1; }

    run_checkpoint

    CHOSEN_ENV=$(whiptail --title "My Quick Debian Setup" --checklist "Selecciona que deseas instalar" \
    20 70 8 \
    "Opera" "Mi navegador preferido" ON \
    "OneDrive" "Instala un cliente GUI para OneDrive" OFF \
    "Obsidian" "Mi app preferida para tomar notas" OFF \
    "VS Code" "El mejor editor de código" OFF \
    "Responsively" "Previsualiza tu web en diferentes dispositivos" OFF \
    "C/C++ Dev Env" "Desarrolla en C/C++ Ahora" OFF \
    "Raylib" "Añade lo necesario para desarrollar en Raylib" OFF \
    "Python + PySide6" "Desarrolla GUI apps en Python Ahora" OFF \
    3>&1 1>&2 2>&3)

    EXIT_STATUS=$?

    if [[ $EXIT_STATUS -eq 0 ]]; then
        if whiptail --yesno "¿Confirmas la instalación de los paquetes seleccionados?" 10 60; then
            print_message "Comenzando la instalación..."
        else
            print_message "Instalación cancelada por el usuario."
            exit 0
        fi

        print_message "Entorno seleccionado $CHOSEN_ENV"

        if [[ $CHOSEN_ENV == *"Opera"* ]]; then
            print_message "Instalando Opera..."
            run_setup_script "install_opera.sh"
        fi
        if [[ $CHOSEN_ENV == *"OneDrive"* ]]; then
            print_message "Instalando OneDrive..."
            run_setup_script "install_onedrive_client.sh"
        fi
        if [[ $CHOSEN_ENV == *"Obsidian"* ]]; then
            print_message "Instalando Obsidian..."
            run_setup_script "install_obsidian.sh"
        fi
        if [[ $CHOSEN_ENV == *"VS Code"* ]]; then
            print_message "Instalando VS Code..."
            run_setup_script "install_VScode.sh"
        fi
        if [[ $CHOSEN_ENV == *"Responsively"* ]]; then
            print_message "Instalando Responsively..."
            run_setup_script "install_responsively.sh"
        fi
        if [[ $CHOSEN_ENV == *"C/C++ Dev Env"* ]]; then
            print_message "Instalando entorno para C/C++..."
            run_setup_script "install_cpp_dev_env.sh"
        fi
        if [[ $CHOSEN_ENV == *"Raylib"* ]]; then
            print_message "Instalando Raylib..."
            run_setup_script "install_raylib.sh"
        fi
        if [[ $CHOSEN_ENV == *"Python + PySide6"* ]]; then
            print_message "Instalando Python + PySide6..."
            run_setup_script "install_homebrew.sh"
            run_setup_script "install_pyenv.sh"
            run_setup_script "install_python_pyside6.sh"
            reload_env
        fi
    fi
}

main

# Final
run_checkpoint
print_message "¡Configuración completa!"
