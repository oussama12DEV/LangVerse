import 'package:flutter/material.dart';
import 'package:langverse/pages/settings/settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsPage(),
      appBar: AppBar(
        elevation: 0.4,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.black,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: const Row(
        children: [],
      ),
    );
  }
}
