import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Posts.dart'; // Import for Post_Widget

class PostsAtLocationScreen extends StatelessWidget {
  final List<DocumentSnapshot> posts; // Pass posts for the specific location

  PostsAtLocationScreen({required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts at Location'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = posts[index].data() as Map<String, dynamic>;
          return Column(
            children: [
              Post_Widget(
                username: data['username'],
                location: data['location'],
                description: data['description'],
                date: data['date'].toDate(),
                rating: data['rating'],
                user: '', // Pass the current user if needed
                PostID: posts[index].id,
              ),
              SizedBox(height: 20), // Spacing between posts
            ],
          );
        },
      ),
    );
  }
}
