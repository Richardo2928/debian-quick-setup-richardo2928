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
reload_env () {
    source ~/.bashrc
}

# Función para ejecutar un script de instalación y recargar el entorno
run_setup_script() {
    # Asigna nombres descriptivos a los parámetros
    local script_name="$1"  # Nombre del proceso de instalación (por ejemplo, "Homebrew")
    local script_path="~/debian-quick-setup-richardo2928/$2"  # Ruta o nombre del script (por ejemplo, "install_brew.sh")

    # Imprime el mensaje de inicio de instalación
    print_message "Instalando ${script_name}..."

    # Verifica si el archivo del script existe y tiene permisos de ejecución
    if [[ -f "$script_path" ]]; then
        chmod +x "$script_path"
        
        # Ejecuta el script en el entorno actual
        ./"$script_path"
        
        # Verifica si el script se ejecutó exitosamente
        if [[ $? -eq 0 ]]; then
            print_message "${script_name} se instaló correctamente."
        else
            print_error "Error al ejecutar ${script_name}."
            exit 1
        fi
    else
        print_error "El archivo de script ${script_path} no existe o no es accesible."
        exit 1
    fi

    # Recarga el entorno para aplicar posibles cambios en el PATH
    reload_env
}


# Crear carpeta para archivos AppImage, si no existe
mkdir -p ~/Apps

# Obtener la ruta de descargas, con fallback
DOWNLOADS_DIR=$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Descargas")

# Fase 1: Instalación de Opera y corrección de formatos de video
print_message "Instalando Opera..."
cd "$DOWNLOADS_DIR"
wget -O opera.deb https://download3.operacdn.com/pub/opera/desktop/102.0.4880.78/linux/opera-stable_102.0.4880.78_amd64.deb
sudo dpkg -i opera.deb
sudo apt --fix-broken install -y
rm opera.deb

if command -v opera &>/dev/null; then
    print_message "Opera se instaló correctamente."
else
    print_error "Error en la instalación de Opera."
    exit 1
fi

print_message "Corrigiendo problemas con formatos de video en Opera..."
git clone https://github.com/nicolas-meilan/fix-opera-linux-ffmpeg
cd fix-opera-linux-ffmpeg/
chmod +x fix-opera.sh
sudo ./fix-opera.sh
cd .. && rm -rf fix-opera-linux-ffmpeg/

# Instalación de OneDriver
print_message "Instalando OneDriver..."
sudo apt install -y curl
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
sudo apt update && sudo apt install -y onedriver

if command -v onedriver &>/dev/null; then
    print_message "OneDriver se instaló correctamente."
else
    print_error "Error en la instalación de OneDriver."
    exit 1
fi

# Instalación de Obsidian
print_message "Instalando Obsidian..."
wget -O ~/Apps/Obsidian.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.13/Obsidian-1.4.13.AppImage
chmod +x ~/Apps/Obsidian.AppImage

if [[ -f ~/Apps/Obsidian.AppImage ]]; then
    print_message "Obsidian se descargó correctamente."
else
    print_error "Error en la descarga de Obsidian."
    exit 1
fi

# CHECKPOINT 1
run_checkpoint

# Instalación de Visual Studio Code
print_message "Instalando Visual Studio Code..."
sudo apt install -y software-properties-common apt-transport-https wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install -y code

if command -v code &>/dev/null; then
    print_message "Visual Studio Code se instaló correctamente."
else
    print_error "Error en la instalación de Visual Studio Code."
    exit 1
fi

# Instalación de Responsively
print_message "Instalando Responsively..."
wget -O ~/Apps/Responsively.AppImage https://github.com/responsively-org/responsively-app-releases/releases/download/v1.15.0/ResponsivelyApp-1.15.0.AppImage
chmod +x ~/Apps/Responsively.AppImage

# Instalación de Git
print_message "Instalando Git..."
if ! command -v git &>/dev/null; then
    sudo apt install -y git
else
    print_message "Git ya está instalado."
fi

# CHECKPOINT 2
run_checkpoint

# Instalación de herramientas de desarrollo C/C++
print_message "Instalando compiladores y utilidades para C/C++..."
sudo apt install -y build-essential gcc g++ binutils cmake ninja-build

if command -v gcc &>/dev/null && command -v g++ &>/dev/null && command -v cmake &>/dev/null; then
    print_message "Herramientas de desarrollo C/C++ instaladas correctamente."
else
    print_error "Error en la instalación de herramientas C/C++."
    exit 1
fi

# Instalación de dependencias para Raylib
print_message "Instalando dependencias para Raylib..."
sudo apt install -y libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev

if dpkg -l | grep -E 'libasound2-dev|libx11-dev|libxrandr-dev|libxi-dev|libgl1-mesa-dev|libglu1-mesa-dev|libxcursor-dev|libxinerama-dev|libwayland-dev|libxkbcommon-dev' &>/dev/null; then
    print_message "Dependencias para Raylib instaladas correctamente."
else
    print_error "Error en la instalación de dependencias para Raylib."
    exit 1
fi

# CHECKPOINT 3
run_checkpoint

# Instalaciones para Python y pyenv
print_message "Instalación de entorno para el desarrollo en Python..."

# Instalación de Homebrew
run_setup_script "Homebrew" "install_homebrew.sh"

# Instalación de pyenv
run_setup_script "Pyenv" "install_pyenv.sh"

# Instalación de Python y Pyside6
run_setup_script "Python y PySide6" "install_python_pyside6.sh"

# Final
run_checkpoint
print_message "¡Configuración completa!"
