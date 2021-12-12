
## Screen orietation 

To turn screen by 90 or 180 degrees. Add this to /boot/userconfig.txt
```
lcd_rotate=2
```
2 is for 180 degress. For 90 degrees, try 1 or 3 (counter-clockwise).

Then reboot.

## Automatic blanking of screen

There are two scripts (`tools/setblank.sh` and `tools/poke.sh`) that will allow blanking 
of the screen after 5 minutes, while keeping it on while playing. Put them in `/usr/local/bin`
on the Raspberry Pi.

Technical details:
 * `xset`: The Volumio touch plugins relies on the X server to do this. We do not run
a X server, so there's no `xset` util.
 * `vbetool`: vbetool (Video Bios) is not available on ARM boards.
 * We settled down on `setterm`: `setterm --blank 1 --powerdown 2` does blank the screen. 
   [See here](https://dietpi.com/phpbb/viewtopic.php?t=8320)).