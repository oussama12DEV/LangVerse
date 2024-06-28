import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:langverse/services/chatrooms_service.dart';

class CreateChatRoomModal extends StatefulWidget {
  @override
  _CreateChatRoomModalState createState() => _CreateChatRoomModalState();
}

class _CreateChatRoomModalState extends State<CreateChatRoomModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String title = '';
  int userLimit = 1;
  String? selectedLanguage;
  List<String> languages = ['French', 'English', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Chat Room Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Limit: $userLimit',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: Slider(
                    value: userLimit.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    onChanged: (double value) {
                      setState(() {
                        userLimit = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              validator: (val) => val == null || val.isEmpty
                  ? 'Please select a language'
                  : null,
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                });
              },
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Language',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ChatroomsService.createChatRoom(
                          title, userLimit, selectedLanguage!)
                      .then((_) {
                    Fluttertoast.showToast(
                      msg: 'Chat room created successfully',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    Navigator.pop(context);
                  }).catchError((e) {
                    Fluttertoast.showToast(
                      msg: e
                          .toString()
                          .replaceAll(RegExp(r'\[.*?\]'), '')
                          .trim(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                }
              },
              child: const Text('Create Chat Room'),
            ),
          ],
        ),
      ),
    );
  }
}
