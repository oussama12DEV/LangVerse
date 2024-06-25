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
      body: SingleChildScrollView(
        // Utiliser SingleChildScrollView pour permettre le défilement
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.darkTheme,
              onChanged: (bool value) {
                themeProvider.darkTheme = value;
              },
            ),
            TextFormField(
              initialValue:
                  'Nom Utilisateur', // Remplacer par la valeur dynamique
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
              readOnly: true, // Rendre le champ en lecture seule
            ),
            TextFormField(
              initialValue:
                  'Email Utilisateur', // Remplacer par la valeur dynamique
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              readOnly: true, // Rendre le champ en lecture seule
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
              },
              child: const Text('Changer le mot de passe'),
            ),
            const Spacer(), // Utiliser Spacer pour pousser le contenu vers le haut
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
