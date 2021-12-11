
# Script to build digiplayer release binary (app.so) to run on Raspberry Pi with flutter-pi
#
# For this to work, you need a linux x64 machine (LINUX_HOST below), and have flutter engine
# binaries in LINUX_WORKDIR, i.e.
#    cd LINUX_WORKDIR; git clone https://github.com/ardera/flutter-engine-binaries-for-arm.git
#
# For more details, see: https://github.com/ardera/flutter-pi#building-the-appso-for-running-your-app-in-releaseprofile-mode


# Change these according to your env

FLUTTER_HOME=~/dev/flutter
APP=digiplayer
LINUX_HOST=brix
LINUX_WORKDIR=work/flutter


# No more changes after this

if ! flutter build bundle; then
  echo Bundle build FAILED; exit 1
fi

echo
echo Building kernel_snapshot.dill ...
if ! dart $FLUTTER_HOME/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot --sdk-root $FLUTTER_HOME/bin/cache/artifacts/engine/common/flutter_patched_sdk_product --target=flutter --aot --tfa -Ddart.vm.product=true --packages .packages --output-dill build/kernel_snapshot.dill --verbose --depfile build\kernel_snapshot.d package:$APP/main.dart;
then
 echo Dill build FAILED; exit 1
fi

if ! rsync -av build --delete $LINUX_HOST:$LINUX_WORKDIR;
then
  echo Upload to Linux failed; exit 1
fi

echo
echo Building app.so...
if ! ssh brix "cd $LINUX_WORKDIR; flutter-engine-binaries-for-arm/arm/gen_snapshot_linux_x64_release --deterministic --snapshot_kind=app-aot-elf --elf=build/flutter_assets/app.so --strip --sim-use-hardfp build/kernel_snapshot.dill";
then
  echo App.so build failed; exit 1
fi

if ! scp brix:work/flutter/build/flutter_assets/app.so build/flutter_assets/;
then
  echo Cannot get app.so from Linux; exit 1
fi

echo
echo SUCCESS!
echo Now just rsync build/flutter_assets to Pi and run it with
echo   flutter-pi --release flutter_assets
