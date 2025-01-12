import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPost_Widget extends StatefulWidget {
  @override
  _NewPost_WidgetState createState() => _NewPost_WidgetState();
}

class _NewPost_WidgetState extends State<NewPost_Widget> {
  // Fields for location, description, rating, and tags
  String? _location; // Selected location name
  double? _latitude; // Latitude of the location
  double? _longitude; // Longitude of the location
  String _description = ''; // Review description
  int _rating = 0; // Rating
  List<String> _tags = []; // Selected tags

  // Tagging variables
  List<String> _allUsers = []; // All users from Firestore
  List<String> _filteredUsers = []; // Filtered users for suggestions
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _tagFocusNode = FocusNode();

  // Places list
  List<Map<String, dynamic>> _places = []; // List of fetched places
  bool _isLoadingPlaces = true; // Loading state for places

  @override
  void initState() {
    super.initState();
    _fetchUsersFromFirestore(); // Fetch users for tagging
    _fetchPlacesFromFirestore(); // Fetch places from Firestore

    // Show suggestions when the tag field is focused
    _tagFocusNode.addListener(() {
      if (_tagFocusNode.hasFocus && _tagController.text.isEmpty) {
        setState(() {
          _filteredUsers = _allUsers; // Show all users if input is empty
        });
      }
    });
  }

  // Fetch users from Firestore for tagging
  Future<void> _fetchUsersFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users') // Adjust collection name if needed
          .limit(50) // Limit to 50 users
          .get();

      setState(() {
        _allUsers = snapshot.docs
            .map((doc) => doc['UserName'] as String) // Map to UserName
            .toList();
        _filteredUsers = _allUsers; // Default to all users
      });

      print('Fetched users: $_allUsers');
    } catch (e) {
      print('Error fetching users from Firestore: $e');
    }
  }

  Future<void> _fetchPlacesFromFirestore() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Places') // Ensure collection name matches
        .get();

    setState(() {
      _places = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('Location') && data.containsKey('coordinates')) {
              GeoPoint geoPoint = data['coordinates'];
              return {
                'location': data['Location'],
                'latitude': geoPoint.latitude,
                'longitude': geoPoint.longitude,
              };
            }
            return null; // Skip invalid documents
          })
          .where((place) => place != null) // Remove null entries
          .cast<Map<String, dynamic>>() // Cast to correct type
          .toList();

      _isLoadingPlaces = false;
    });

    print('Fetched places: $_places');
  } 
  

  // Filter users based on input
  void _filterUsers(String input) {
    setState(() {
      if (input.isEmpty) {
        _filteredUsers = _allUsers; // Show all users if input is empty
      } else {
        _filteredUsers = _allUsers
            .where((user) => user.toLowerCase().startsWith(input.toLowerCase()))
            .toList();
      }
    });
  }

  // Save the post to Firestore
  Future<void> _savePost(BuildContext context, String user) async {
    if (_rating == 0 || _location == null || _description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Posts').add({
        'username': user,
        'location': _location,
        'coordinates': GeoPoint(_latitude!, _longitude!),
        'description': _description,
        'rating': _rating,
        'tags': _tags,
        'likes': [],
        'date': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NewPost_Widget(),
        settings: RouteSettings(arguments: user),),
      );
    } catch (e) {
      print('Failed to save post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2642),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NewPost_Widget(),
                  settings: RouteSettings(arguments: user),),
                ); // Go back
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Expanded(
              child: Text(
                'Been There',
                style: TextStyle(color: Colors.white, fontSize: 36.0),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () => _savePost(context, user), // Save post
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Recommend a place\nanywhere in the world!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Places dropdown or loading indicator
              _isLoadingPlaces
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<Map<String, dynamic>>(
                      decoration: InputDecoration(
                        labelText: 'Select a Place',
                        border: OutlineInputBorder(),
                      ),
                      items: _places.map((place) {
                        return DropdownMenuItem(
                          value: place,
                          child: Text(place['location']), // Display place name
                        );
                      }).toList(),
                      onChanged: (selectedPlace) {
                        setState(() {
                          _location = selectedPlace!['location'];
                          _latitude = selectedPlace['latitude'];
                          _longitude = selectedPlace['longitude'];
                        });
                      },
                    ),

              const SizedBox(height: 16),

              // Description input
              TextField(
                onChanged: (value) => _description = value,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Tagging field
              TextField(
                controller: _tagController,
                focusNode: _tagFocusNode,
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_add_alt),
                  hintText: 'Tag a friend',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Suggestions list
              if (_tagFocusNode.hasFocus)
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        title: Text(user),
                        onTap: () {
                          if (!_tags.contains(user)) {
                            setState(() {
                              _tags.add(user); // Add user to tags
                              _tagController.clear(); // Clear input
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),

              // Selected tags
              Wrap(
                spacing: 8.0,
                children: _tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() {
                            _tags.remove(tag); // Remove tag
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Rating stars
              Text(
                'Your final rate for this location:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      _rating > index ? Icons.star : Icons.star_border,
                      color: const Color(0xFF1A2642),
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NewPostMenu(context, user),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }
}
