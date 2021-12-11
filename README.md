EN | [中文](README.zh.md)

# DigiPlayer - A Clean UI for Volumio 3

DigiPlayer is a clean touch UI for Volumio 3, written in Flutter for the Raspberry Pi Touch Display.

Feng Zhou, 2021-12



This is a simple user interface for Volumio 3, the Linux distribution for music playback.
I wrote it for playing music with the Raspberry Pi + 7-inch touch screen. The end result
looks like this,

<img src="doc/digiplayer.jpeg" width="600">

Features,
 * Designed for landscape mode. The Volumio touch screen plugin works best in portrait.
 * Good performance even on Raspberry Pi 3.
 * Touch-native UI similar to mobile apps. It runs on flutter-pi and no X-window is used.

## Building DigiPlayer

Before this gets packaged as a Volumio plugin, here is what you need to build DigiPlayer
from scratch,

 * Raspberry Pi 3 or 4.
 * Official Raspberry Pi 7-inch touch display.
 * Your dev computer (Windows/Mac/Linux)
 * A Linux x64 computer or VM (for compiling app.so)

First, take a look at [flutter engine binaries](https://github.com/ardera/flutter-engine-binaries-for-arm) repository to see which version of Flutter is available for Raspberry Pi.
As of writing it is 2.5.3.

Go ahead and install that [version of Flutter](https://docs.flutter.dev/development/tools/sdk/releases) on the dev computer.

Check out [flutter engine binaries](https://github.com/ardera/flutter-engine-binaries-for-arm) on the **Linux computer**.
```
mkdir -p work/flutter
cd work/flutter
git clone https://github.com/ardera/flutter-engine-binaries-for-arm
```

Build DigiPlayer on **dev computer**
```
cd digiplayer

# Check build_release.sh for changes of dir locations, etc.
# This script build the flutter bundle locally, then ssh to the linux box to build app.so
# Then check lib/main.dart for changes to serverAddr (volumio.local works for me), defaultDir, etc.
./build_release.sh

# If successful, build/flutter_assets will contain artifacts, including app.so
```

Assuming [Volumio 3](https://volumio.lpages.co/volumio-3/) is already installed on Pi, follow instructions on [flutter-pi page](https://github.com/ardera/flutter-pi) to install flutter-pi, the Flutter runtime for Pi. Compilation should only take a few minutes.

Now you can finally get the app onto Pi, and run it,
```
rsync -av build/flutter_assets/* volumio@volumio.local:digiplayer/
ssh volumio@volumio.local
flutter-pi --release digiplayer
```

You should see DigiPlayer as shown at the beginning of this README.

Optionally you can add it to /etc/rc.local to run every time Pi starts up,
```
runuser -l volumio -c "/usr/local/bin/flutter-pi /home/volumio/digiplayer" &
```

## Why Volumio?

Here is what I like about this setup,
 * *It plays music anywhere in the home network*. I mostly use the device to play music files stored in a NAS. It is very convenient. I do not even need to touch the device to add new music.
 * *Good audio quality with digital connections*. I attached a [HiFi Berry Digi](https://www.hifiberry.com/digis/) compatible HAT to the Pi, and output audio through SPDIF fiber to my soundbar. I 3D-printed a [back-cover](tools/case/case_side.jpg) ([OpenSCAD design here](tools/case/)) for better looks.
 * *Use your phone as a remote*. Just point phone browser to http://volumio.local. Then you can browse and control your music playing there, from couch or anywhere. The Pi's play screen stays synchronized. On iPhone, touch `share->add to home screen` for easier access later.
 * Volumio has [a tons of audio features](https://volumio.lpages.co/volumio-3/) that I have not find time to explore yet.