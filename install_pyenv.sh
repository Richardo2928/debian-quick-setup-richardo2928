#!/bin/bash

# Instala dependencias de pyenv
sudo apt install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev libedit-dev

# Exportar Homebrew al entorno actual
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Instala pyenv a tráves de brew
brew install pyenv

# Añade pyenv al PATH en ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
