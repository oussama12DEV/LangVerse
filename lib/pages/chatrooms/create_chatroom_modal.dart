import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:langverse/services/chatrooms_service.dart'; // Import your chatrooms_service file here

class CreateChatRoomModal extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController userLimitController = TextEditingController();
  final TextEditingController languageController = TextEditingController();

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
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Chat Room Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: userLimitController,
              decoration: const InputDecoration(labelText: 'User Limit'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a user limit';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: languageController,
              decoration: const InputDecoration(labelText: 'Language'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a language';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String title = titleController.text;
                  int userLimit = int.parse(userLimitController.text);
                  String language = languageController.text;

                  // Call your service method to create chat room
                  ChatroomsService.createChatRoom(title, userLimit, language)
                      .then((_) {
                    // Show success message
                    Fluttertoast.showToast(
                      msg: 'Chat room created successfully',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // Close the modal
                    Navigator.pop(context);
                  }).catchError((e) {
                    // Show error message
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
