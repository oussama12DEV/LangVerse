import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:langverse/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';
  String dob = '';
  String gender = '';
  String preferredLanguage = '';
  bool _showAdditionalFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                onChanged: (val) {
                  setState(() => username = val);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter a valid Email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                obscureText: true,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (val) {
                  if (val!.isEmpty) return 'Please confirm password';
                  if (password != confirmPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() => confirmPassword = val);
                },
                obscureText: true,
              ),
              if (_showAdditionalFields) ...[
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      suffixIcon: Icon(Icons.calendar_today)),
                  validator: (val) =>
                      val!.isEmpty ? 'Select a Date of Birth' : null,
                  onChanged: (val) {
                    setState(() => dob = val);
                  },
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2025),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dob =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: dob,
                  ),
                ),
                DropdownButtonFormField<String>(
                  validator: (val) =>
                      val!.isEmpty ? 'Select Your Gender' : null,
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                  ),
                ),
                DropdownButtonFormField<String>(
                  validator: (val) =>
                      val!.isEmpty ? 'Select Your Preferred Language' : null,
                  onChanged: (newValue) {
                    setState(() {
                      preferredLanguage = newValue!;
                    });
                  },
                  items: <String>['French', 'English', 'Spanish']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Preferred Language',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_showAdditionalFields) {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _showAdditionalFields = true;
                      });
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.registerWithEmailPassword(
                        email,
                        password,
                        username,
                        dob,
                        gender,
                        preferredLanguage,
                      );
                      if (result != null) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    }
                  }
                },
                child: Text(_showAdditionalFields ? 'Sign Up' : 'Next'),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google),
                    color: Colors.red,
                    iconSize: 45,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    color: Colors.blue,
                    iconSize: 45,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Already have an Account? Login Now.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
