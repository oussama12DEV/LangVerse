import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DuelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final duelId = routeArgs['id'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Duel Page'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('quiz_duels')
              .doc(duelId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Duel not found');
            }

            final duelData = snapshot.data!.data() as Map<String, dynamic>;
            final user1Id = duelData['user1Id'] as String;
            final user2Id = duelData['user2Id'] as String;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('User 1: $user1Id'), // Replace with actual user info
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey, // Placeholder for profile picture
                ),
                SizedBox(height: 20),
                Text('User 2: $user2Id'), // Replace with actual user info
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey, // Placeholder for profile picture
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
