import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langverse/services/editprofil.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _preferredLanguage;
  String dob = '';
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    var userDoc = await _userService.initializeUserData();
    if (userDoc != null) {
      setState(() {
        _nameController.text = userDoc['username'];
      });
    }
  }

  Future<void> _saveChanges() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    _userService.saveChanges(uid, _nameController.text, dob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
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
                    _selectedDate = pickedDate;
                    dob =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                    : '',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              validator: (val) => val!.isEmpty ? 'Selected your Gender' : null,
              value: _selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: <String>['Homme', 'Femme', 'Autre']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Sexe',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              validator: (val) =>
                  val!.isEmpty ? 'Selected your Perfect Language' : null,
              value: _preferredLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _preferredLanguage = newValue!;
                });
              },
              items: <String>['Français', 'Anglais', 'Espagnol']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Langue préférée',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
