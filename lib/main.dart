import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(Langverse());
}

class Langverse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Langverse',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.light(
          primary: Colors.pinkAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
         '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
