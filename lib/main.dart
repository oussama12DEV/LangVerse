import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langverse/firebase_options.dart';
import 'package:langverse/pages/settings_page.dart';
import 'package:langverse/preferences/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/index_page.dart';

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
  Widget _routeWrapper({required Widget child, bool requireAuth = true}) {
    return Builder(
      builder: (context) {
        final user = FirebaseAuth.instance.currentUser;
        if (requireAuth && user == null) {
          return LoginPage();
        } else if (!requireAuth && user != null) {
          return IndexPage();
        }
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Langverse',
      theme: themeProvider.darkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    return LoginPage();
                  }
                  return IndexPage();
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),
        '/login': (context) =>
            _routeWrapper(child: LoginPage(), requireAuth: false),
        '/register': (context) =>
            _routeWrapper(child: RegisterPage(), requireAuth: false),
        '/index': (context) => _routeWrapper(child: IndexPage()),
      },
    );
  }
}
