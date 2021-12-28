
# Script to build Volumio Touch Display Lite release binary (app.so) to run on Raspberry Pi with flutter-pi
#
# For this to work, you need a linux x64 machine (LINUX_HOST below), and have flutter engine
# binaries in LINUX_WORKDIR, i.e.
#    cd LINUX_WORKDIR; git clone https://github.com/ardera/flutter-engine-binaries-for-arm.git
#
# For more details, see: https://github.com/ardera/flutter-pi#building-the-appso-for-running-your-app-in-releaseprofile-mode


# Change these according to your env

FLUTTER_HOME=~/dev/flutter
APP=touch_display_lite
LINUX_HOST=brix
LINUX_WORKDIR=work/flutter


# No more changes after this

if ! flutter build bundle; then
  echo Bundle build FAILED; exit 1
fi

echo
echo Build SUCCESS!
echo Now just rsync build/flutter_assets to Pi and run it with
echo   flutter-pi flutter_assets
