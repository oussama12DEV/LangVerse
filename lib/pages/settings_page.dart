// Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:langverse/preferences/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark Mode'),
          value: themeProvider.darkTheme,
          onChanged: (bool value) {
            themeProvider.darkTheme = value;
          },
        ),
      ),
    );
  }
}
