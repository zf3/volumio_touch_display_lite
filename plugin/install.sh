#!/bin/bash

ID=$(awk '/VERSION_ID=/' /etc/*-release | sed 's/VERSION_ID=//' | sed 's/\"//g')

echo "Install flutter-pi dependencies"
apt install cmake libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev libudev-dev  libxkbcommon-dev

echo "Refreshing font cache"
fc-cache

echo "Configuring video driver (V3D)"
if ! grep -q "vc4-fkms-v3d" /boot/config.txt; then
    echo "dtoverlay=vc4-fkms-v3d
gpu_mem=64
" >> /boot/config.txt
fi

/usr/sbin/usermod -a -G render volumio

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
