import 'package:flutter/material.dart';

class ChatroomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // Center the Container
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Add some horizontal padding
            width: MediaQuery.of(context).size.width *
                0.8, // Make the Container take 80% of the AppBar's width
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(
                  20.0), // Increase border radius for more rounded corners
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search,
                    color: Colors.grey), // Icon color for better visibility
                border: OutlineInputBorder(
                  // Use OutlineInputBorder for rounded corners
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)), // Match Container's borderRadius
                  borderSide: BorderSide.none, // No actual border
                ),
                fillColor: Colors.white, // Background color of the TextField
                filled: true, // Enable the fillColor for TextField
              ),
            ),
          ),
        ),
      ),
      body: const Row(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define the action when the button is pressed
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
