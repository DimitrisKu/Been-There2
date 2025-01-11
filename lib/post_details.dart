import 'package:flutter/material.dart';

class PostDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the post ID passed as an argument
    final String postId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Post ID: $postId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the map
              },
              child: const Text('Back to Map'),
            ),
          ],
        ),
      ),
    );
  }
}
