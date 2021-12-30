import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import "main.dart";
import 'package:restart_app/restart_app.dart';
import 'dart:io';
import 'package:vk/vk.dart';

bool debug = false;

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsWidget> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Restart"),
      onPressed: () {
        Restart.restartApp();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Restart the app to connect to new server?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showInputDialog(BuildContext context, String title, String initial,
      void Function(String text) onChange) {
    // set up the textt field and virtual keyboard
    TextEditingController controller = TextEditingController(text: initial);
    TextField text = TextField(
      controller: controller,
    );
    VirtualKeyboard vk = VirtualKeyboard(
        type: VirtualKeyboardType.Alphanumeric,
        height: 150,
        textController: controller);
    Widget okBtn = TextButton(
      child: const Text("OK"),
      onPressed: () {
        onChange(controller.text.trim());
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget cancelBtn = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    // set up the input dialog
    SimpleDialog dialog = SimpleDialog(title: Text(title), children: [
      text,
      vk,
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [cancelBtn, okBtn])
    ]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: 'Settings', children: [
      SwitchSettingsTile(
          title: 'Dark Mode',
          settingKey: 'dark_mode',
          onChange: (v) {
            appKey.currentState?.setDarkMode(v);
            if (debug) debugPrint("Prefs: ${prefCache.getKeys()}");
          }),
      SimpleSettingsTile(
          title: 'Default Directory',
          subtitle: defaultDir,
          onTap: () {
            showInputDialog(context, 'Default Directory', defaultDir, (text) {
              defaultDir = text;
              Settings.setValue('default_dir', text);
              if (debug) debugPrint("Prefs: ${prefCache.getKeys()}");
              setState(() {});
            });
          }),
      ExpandableSettingsTile(title: 'More...', children: [
        SimpleSettingsTile(
          title: "Server Address",
          subtitle: serverAddr,
          onTap: () {
            showInputDialog(context, 'Server Address', serverAddr, (text) {
              serverAddr = text;
              Settings.setValue('server_addr', text);
              if (debug) debugPrint("Prefs: ${prefCache.getKeys()}");
              setState(() {});
            });
          },
        ),
        SimpleSettingsTile(
            title: 'Exit the App',
            subtitle: '',
            onTap: () {
              debugPrint(
                  'Exiting touch_display_lite app by calling exit(0)...');
              exit(0);
            })
      ])
    ]);
  }
}
