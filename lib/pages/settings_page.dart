// Import necessary packages
import 'package:flutter/material.dart';
import 'package:langverse/services/auth_service.dart';
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
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.darkTheme,
              onChanged: (bool value) {
                themeProvider.darkTheme = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
