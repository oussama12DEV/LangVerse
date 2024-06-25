import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:langverse/firebase_options.dart';
import 'package:langverse/pages/settings_page.dart';
import 'package:langverse/preferences/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => DarkThemeProvider(),
      child: Langverse(),
    ),
  );
}

class Langverse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Langverse',
      theme: themeProvider.darkTheme ? ThemeData.dark() : ThemeData.light(),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
