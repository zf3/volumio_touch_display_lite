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
# Go to https://github.com/zf3/volumio_touch_display_lite and download plugin zip file.
mkdir ./touch_display_lite
miniunzip touch_display_lite.zip -d ./touch_display_lite
cd ./touch_display_lite
volumio plugin install
```
If the installation fails, remove all file (if any) related to the plugin before retry.

Now enable the plugin through the Web interface.

### Changelog

2021-12-19

- First release: 0.1.0.