
## Screen orietation 

To turn screen by 90 or 180 degrees. Add this to /boot/userconfig.txt
```
lcd_rotate=2
```
2 is for 180 degress. For 90 degrees, try 1 or 3 (counter-clockwise).

Then reboot.

## Internation fonts
 * To display Chinese text, install CJK fonts with: `sudo apt install fonts-noto-cjk`. Or characters show up as squares.

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