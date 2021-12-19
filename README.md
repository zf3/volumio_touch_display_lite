EN | [中文](README.zh.md)

# Touch Display Lite plugin for Volumio 3

Feng Zhou, 2021-12

Touch Display Lite is a clean and fast user interface for Volumio 3, the Linux distribution for music playback.
It works with Raspberry Pi and the official 7-inch touch screen (and potentially other touch screens). Written in
[Flutter](https://flutter.dev/) and using the fast [flutter-pi](https://github.com/ardera/flutter-pi) runtime, it aims
to be fast, minimalistic and modern.

The end result looks like this,

<img src="doc/digiplayer.jpeg" width="600">

Features,
 * Designed for landscape mode. The official Volumio [Touch Display plugin](https://community.volumio.org/t/plugin-touch-display/10647) works best in portrait.
 * Good performance even on Raspberry Pi 3.
 * Touch-native UI similar to mobile apps. It runs on flutter-pi and no X-window is used.

Limitations,
 * Functions are minimal, for example only playing from the music library, not streaming service, etc.

## Using Touch Display Lite

Touch Display Lite is a plugin to Volumio 3. It is written with Raspberry Pi 3 or 4, 
and the Official Raspberry Pi 7-inch touch display in mind. To try it, first set up Volumio on
Raspberry Pi. Then downloading Touch Display Lite and set up as follows,

 1. If you haven't done so, enable SSH access to Volumio by visiting [volumio.local/dev](http://volumio.local/dev).
 2. Get `touch_display_lite.zip` to volumio and unzips to a tmp dir.
 3. In the dir: `volumio plugin install`
 4. If you need Chinese font: `sudo apt install -y fonts-noto-cjk`
 5. REBOOT (by `reboot`) to load video driver and fix screen rotation
 6. Enable the plugin.

## Building from Source

Here are instructions to build Touch Display Lite from scratch. You need,

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

Build Touch Display Lite on **dev computer**
```
cd touch_display_lite

# Check build_release.sh for changes of dir locations, etc.
# This script build the flutter bundle locally, then ssh to the linux box to build app.so
# Then check lib/main.dart for changes to serverAddr (volumio.local works for me), defaultDir, etc.
./build_release.sh

# If successful, build/flutter_assets will contain artifacts, including app.so
# The plugin will be at build/touch_display_lite.zip
```

Assuming [Volumio 3](https://volumio.lpages.co/volumio-3/) is already installed on Pi, follow instructions on [flutter-pi page](https://github.com/ardera/flutter-pi) to install flutter-pi, the Flutter runtime for Pi. Compilation should only take a few minutes.

Now you can get the app onto Pi, and run it to see if it works,
```
rsync -av build/flutter_assets/* volumio@volumio.local:digiplayer/
ssh volumio@volumio.local
flutter-pi --release touch_display_lite
```

You should see Touch Display Lite as shown at the beginning of this README.

To actually install the plugin into Volumio, use `build/touch_display_lite.zip`
```
mkdir touch_display_lite
miniunzip touch_display_lite.zip -d touch_display_lite
cd touch_display_lite
volumio plugin install
```
Then go to Volumio web interface, and go to `Plugins->Installed` to launch Touch Display Lite.

## Why Volumio?

Here is what I like about this setup,
 * *It plays music anywhere in the home network*. I mostly use the device to play music files stored in a NAS. It is very convenient. I do not even need to touch the device to add new music.
 * *Good audio quality with digital connections*. I attached a [HiFi Berry Digi](https://www.hifiberry.com/digis/) compatible HAT to the Pi, and output audio through SPDIF fiber to my soundbar. I 3D-printed a [back-cover](tools/case/case_side.jpg) ([OpenSCAD design here](tools/case/)) for better looks.
 * *Use your phone as a remote*. Just point phone browser to http://volumio.local. Then you can browse and control your music playing there, from couch or anywhere. The Pi's play screen stays synchronized. On iPhone, touch `share->add to home screen` for easier access later.
 * Volumio has [a tons of audio features](https://volumio.lpages.co/volumio-3/) that I have not find time to explore yet.