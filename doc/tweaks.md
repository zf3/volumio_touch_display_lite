
## Screen orietation 

To turn screen by 90 or 180 degrees. Add this to /boot/userconfig.txt
```
lcd_rotate=2
```
2 is for 180 degress. For 90 degrees, try 1 or 3 (counter-clockwise).

Then reboot.

## 7-inch HDMI touch screen

 * Font is tiny on the 7-inch HDMI touch screen. This is because the screen is a non-standard resolution (1024*600). And flutter-pi uses the default 1920-1080 resolution, which is too high.
```
[flutter-pi] WARNING: display didn't provide valid physical dimensions.
Dec 21 15:43:40 volumio flutter-pi[1101]:              The device-pixel ratio will default to 1.0, which may not be the fitting device-pixel ratio for your display.
Dec 21 15:43:41 volumio flutter-pi[1101]: ===================================
Dec 21 15:43:41 volumio flutter-pi[1101]: display mode:
Dec 21 15:43:41 volumio flutter-pi[1101]:   resolution: 1920 x 1080
```
 We fixed this by adding these to /boot/config.txt (setting the custom mode):
```
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60 6 0 0 0
```
 * Now flutter-pi picks up the right resolution. But font is still a bit small, due to unknown device-pixel ratio. Flutter-pi needs the physical dimension of the display to determine this.
   * Width of display: 177.8 / 1187 * 1024 = 153
   * Height of display: 177.8 / 1187 * 600 = 90
   So we change the command line in `/lib/sys/systemd/system/touch_display_lite.service` to,
 ```
 ExecStart=/data/plugins/user_interface/touch_display_lite/flutter-pi --release -d "153,90" /data/plugins/user_interface/touch_display_lite/flutter_assets
 ```
   This fixes the problem completely.

## International fonts
 * To display Chinese text, install CJK fonts with: `sudo apt install fonts-noto-cjk`. Or characters show up as squares.
 * [Add locales](https://medium.com/@timcase/adding-locales-to-the-pi-for-raspbian-lite-a345c712239c)

## Automatic blanking of screen

Technical details:
 * We turn on the backlight with this (0 for turning-off): `echo 255 > /sys/class/backlight/rpi_backlight/brightness`. From [here](https://forums.raspberrypi.com/viewtopic.php?t=120296).

Other older methods:
 * `xset`: The Volumio touch plugins relies on the X server to do this. We do not run
a X server, so there's no `xset` util.
 * `vbetool`: vbetool (Video Bios) is not available on ARM boards.
 * We tried `setterm` but it's unreliable: `setterm --blank 1 --powerdown 2` does blank the screen. [See here](https://dietpi.com/phpbb/viewtopic.php?t=8320)).

## Clean installation on Volumio 3

 * `sudo apt update`
 * `apt install vim`
 * `/boot/userconfig.txt` `lcd_rotate=2`
 * `sudo journalctl -f`
 * Copy icudtl.dat and libflutter_engine.so.release to /usr/lib
```
[locales] Warning: The system has no configured locale. The default "C" locale may or may not be supported by the app.
[keyboard] Could not load keyboard configuration from "/etc/default/keyboard". Default keyboard config will be used. load_file: No such file or directory
[flutter-pi] Could not query DRM device list: No such file or directory
```
  both `gpu_mem=32` and `gpu_mem=64` are in /boot/config.txt
 * Missing Chinese fonts: `Noto Sans CJK SC`: `apt install fonts-noto-cjk`

# Clean installation on Volumio 3 - run 2
 1. Flash SD card
 2. Boot: screen is upside down
 3. Web UI setup wizard
 5. Add NAS source
 4. volumio.local/dev to enable SSH
 6. scp touch_display_lite.zip to volumio, unzip to dir
 7. `volumio plugin install`
 8. `sudo apt install -y fonts-noto-cjk` to install Chinese fonts
 9. Reboot to fix screen rotation
 10. Enable the plugin.