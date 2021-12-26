2021-12-19

# Touch Display Lite Plugin

Author: Feng Zhou

Touch Display Lite is a clean and fast user interface for Volumio 3.
It works with the official 7-inch touch screen (and potentially other touch screens). Written in
[Flutter](https://flutter.dev/) and using the fast [flutter-pi](https://github.com/ardera/flutter-pi) runtime, it aims
to be fast, minimalistic and modern.

## How to install

### 1. Enable SSH and connect to Volumio

For security reasons, SSH is disabled by default on all versions after 2.199 (except first boot). It can be however enabled very easily.

Navigate to the DEV ui by pointing your browser to http://VOLUMIOIP/DEV or http://volumio.local/DEV . Find the SSH section, and click enable. From now on your SSH will be permanently enabled.

Now you can connect to Volumio with username `volumio` and password `volumio`.

```
ssh volumio@volumio.local (if you changed the name of your device, replace the second volumio by it or use its IP address.
```

### 2. Download and install the plugin

Type the following commands to download and install plugin:

```
# First go to https://github.com/zf3/volumio_touch_display_lite/releases and download the latest plugin zip file. Then,
mkdir ./touch_display_lite
miniunzip touch_display_lite.zip -d ./touch_display_lite
cd ./touch_display_lite
volumio plugin install
```
If the installation fails, remove all file (if any) related to the plugin before retry.

Now enable the plugin through the Web interface.

## Settings for screens

### Raspberry Pi 7-in Touch Display

This is what the plugin is written for and works best. It should just works.

A few things to tweak:
 * **Upside-down display**. Screen rotation can be set by editing `/boot/config.txt`. `lcd_rotate=2` is what works for me. It could be 1,2,3 or 4.
 * **International (Chinese, Japanses) text shows up as squares**. To display Chinese text, install CJK fonts with: `sudo apt install fonts-noto-cjk`.

### HDMI touch screens

These may need some changes to work properly.

 * **Tiny text**. This is likely due to the Linux kernel not picking up the native resolution of the display. Googling for HDMI settings for the specific screen model should help. It probably involves changing `/boot/config.txt`. 
   * Example: One 7-inch HDMI screen uses `1920x1080` while native resolution is `1024x600`. It was fixed by two changes. First, these were added to `/boot/config.txt`:
     ```
     hdmi_group=2
     hdmi_mode=87
     hdmi_cvt=1024 600 60 6 0 0 0
     ```
     Second, an option was added to `flutter-pi` startup script (`/lib/sys/systemd/system/touch_display_lite.service`) specifying physical dimension of the screen,
     ```
     ExecStart=/data/plugins/user_interface/touch_display_lite/flutter-pi --release -d "153,90" /data/plugins/user_interface/touch_display_lite/flutter_assets
     ```
     The screen is 153mm by 90mm in size.
 * **Other problems, like blank screen, etc**. The plugin uses DRM(Direct Rendering Manager) and OpenGL ES/EGL to render graphics. So for display to work properly, DRM and EGL need to be working. The Raspberry Pi [documentation for config.txt](https://www.raspberrypi.com/documentation/computers/config_txt.html) is a good place to start. `sudo journalctl -f` shows log when starting the plugin and can be helpful. 

## Changelog

2021-12-19

- First release: 0.1.0. Ships with Flutter 2.5.3.