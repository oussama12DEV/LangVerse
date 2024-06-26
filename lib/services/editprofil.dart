import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>?> initializeUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return await _db.collection('users').doc(currentUser.uid).get();
    }
    return null;
  }

  Future<void> saveChanges(String uid, String username, String dob) async {
    await _db.collection('users').doc(uid).update({
      'username': username,
      'dateOfBirth': dob,
    });

    Fluttertoast.showToast(
      msg: 'Profile updated successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
