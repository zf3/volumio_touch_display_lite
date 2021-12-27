import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import "main.dart";
import 'package:restart_app/restart_app.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: 'Settings', children: [
      SwitchSettingsTile(
          title: 'Dark Mode',
          settingKey: 'dark_mode',
          onChange: (v) {
            appKey.currentState?.setDarkMode(v);
            debugPrint("Prefs: ${prefCache.getKeys()}");
          }),
      TextInputSettingsTile(
          title: 'Default Directory',
          settingKey: 'default_dir',
          initialValue: 'music-library',
          onChange: (v) {
            defaultDir = v;
            debugPrint("Prefs: ${prefCache.getKeys()}");
          }),
      TextInputSettingsTile(
        title: "Server Address",
        settingKey: 'server_addr',
        initialValue: 'localhost',
        onChange: (v) {
          serverAddr = v;
          debugPrint("Prefs: ${prefCache.getKeys()}");
          showAlertDialog(context);
        },
      ),
      ExpandableSettingsTile(title: 'More...', children: [
        SimpleSettingsTile(
            title: 'Exit the App',
            subtitle: '',
            onTap: () {
              debugPrint('Exiting app by calling exit(0)...');
              exit(0);
            })
      ])
    ]);
  }
}
