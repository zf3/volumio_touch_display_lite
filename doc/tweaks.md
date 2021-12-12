
## Screen orietation 

To turn screen by 90 or 180 degrees. Add this to /boot/userconfig.txt
```
lcd_rotate=2
```
2 is for 180 degress. For 90 degrees, try 1 or 3 (counter-clockwise).

Then reboot.

## Automatic blanking of screen

Technical details:
 * We turn on the backlight with this (0 for turning-off): `echo 255 > /sys/class/backlight/rpi_backlight/brightness`. From [here](https://forums.raspberrypi.com/viewtopic.php?t=120296).

Other older methods:
 * `xset`: The Volumio touch plugins relies on the X server to do this. We do not run
a X server, so there's no `xset` util.
 * `vbetool`: vbetool (Video Bios) is not available on ARM boards.
 * We tried `setterm` but it's unreliable: `setterm --blank 1 --powerdown 2` does blank the screen. [See here](https://dietpi.com/phpbb/viewtopic.php?t=8320)).
