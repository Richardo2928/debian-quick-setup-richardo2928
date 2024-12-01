#Instalación de Opera y corrección de formatos de video
# Instalación de Opera
cd "$DOWNLOADS_DIR"
wget -O opera.deb https://download3.operacdn.com/pub/opera/desktop/102.0.4880.78/linux/opera-stable_102.0.4880.78_amd64.deb
sudo dpkg -i opera.deb
sudo apt --fix-broken install -y
rm opera.deb

# Corrigiendo problemas con formatos de video en Opera...
git clone https://github.com/nicolas-meilan/fix-opera-linux-ffmpeg
cd fix-opera-linux-ffmpeg/
chmod +x fix-opera.sh
sudo ./fix-opera.sh
cd .. && rm -rf fix-opera-linux-ffmpeg/