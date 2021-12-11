import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings 设置'));
  }
}
