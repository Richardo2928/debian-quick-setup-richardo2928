# Instalación de OneDriver
# TODO: Permir al usuario elegir que cliente para OneDrive usar
sudo apt install -y curl
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null
sudo apt update && sudo apt install -y onedriver