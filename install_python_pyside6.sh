#!/bin/bash

# Asegúrate de que pyenv esté en el PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Instala Python 3.11
pyenv install 3.11
pyenv global 3.11

# Actualiza pip y luego instala PySide6
pip install --upgrade pip
pip install pyside6
