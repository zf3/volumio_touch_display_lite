#!/bin/bash

ID=$(awk '/VERSION_ID=/' /etc/*-release | sed 's/VERSION_ID=//' | sed 's/\"//g')
PDIR=/data/plugins/user_interface/touch_display_lite

echo "Install flutter-pi dependencies"
sudo apt update
if ! sudo DEBIAN_FRONTEND=noninteractive apt install -y libgl1 libgles2-mesa ttf-mscorefonts-installer fontconfig libegl1 libinput10 libgbm1;
then
  echo Cannot install dependencies; exit 1
fi

# uncomment next line to install Chinese fonts
# sudo DEBIAN_FRONTEND=noninteractive apt install -y fonts-noto-cjk

echo "Refreshing font cache"
fc-cache

echo "Configuring video driver (V3D)"
if ! grep -q "vc4-fkms-v3d" /boot/config.txt; then
    echo "dtoverlay=vc4-fkms-v3d
gpu_mem=64
lcd_rotate=2
" >> /boot/config.txt
fi

/usr/sbin/usermod -a -G render volumio
cp $PDIR/icudtl.dat $PDIR/libflutter_engine.so.release /usr/lib
# 

chmod +x /data/plugins/user_interface/touch_display_lite/flutter-pi

echo "Creating Systemd Unit for Touch Display Lite"
echo "[Unit]
Description=Volumio Touch Display Lite
Wants=volumio.service
After=volumio.service
[Service]
Type=simple
User=root
Group=root
ExecStart=/data/plugins/user_interface/touch_display_lite/flutter-pi --release /data/plugins/user_interface/touch_display_lite/flutter_assets
[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/touch_display_lite.service
systemctl daemon-reload

echo "plugininstallend"
