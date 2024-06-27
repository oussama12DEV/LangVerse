import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logic to change the password
          },
          child: const Text('Change Password'),
        ),
      ),
    );
  }
}
