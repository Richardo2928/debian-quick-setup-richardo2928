#!/bin/bash
# Exportar variables de pyenv directamente
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Recargar pyenv en el entorno actual
eval "$(pyenv init --path)"
# Instala Python 3.11 a tráves de pyenv
pyenv install 3.11
pyenv global 3.11

# Actualiza pip y luego instala PySide6
pip install --upgrade pip
pip install pyside6
