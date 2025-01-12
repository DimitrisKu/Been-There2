import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class NewPost_Widget extends StatefulWidget {
  @override
  _NewPost_WidgetState createState() => _NewPost_WidgetState();
}

class _NewPost_WidgetState extends State<NewPost_Widget> {
  String? _location; // Selected location name
  double? _latitude; // Latitude of the selected location
  double? _longitude; // Longitude of the selected location
  String _description = ''; // User's review
  int _rating = 0; // Rating for the post
  List<String> _tags = []; // List of tagged users
  List<String> _userSuggestions = []; // List of user suggestions for tagging

  final FocusNode _tagFieldFocusNode = FocusNode(); // Focus node for tagging field
  bool _showSuggestions = false; // To control visibility of the suggestions list

  @override
  void initState() {
    super.initState();
    _fetchInitialUsers(); // Fetch 5 users initially
        
        
    // Listen to the focus changes of the tagging text field
    _tagFieldFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _tagFieldFocusNode.hasFocus;
      });
    });
  }

  // Fetch the first 5 users from Firestore when the input is empty
  Future<void> _fetchInitialUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .limit(5) // Fetch only 5 users
        .get();

    setState(() {
      _userSuggestions = snapshot.docs
          .map((doc) => doc['UserName'] as String) // Map to UserName field
          .toList();
    });
  }

  // Fetch users based on input text
  Future<void> _fetchMatchingUsers(String value) async {
    if (value.isEmpty) {
      await _fetchInitialUsers(); // Fetch default 5 users when input is empty
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('UserName', isGreaterThanOrEqualTo: value)
        .where('UserName', isLessThanOrEqualTo: value + '\uf8ff') // Match prefix
        .get();

    setState(() {
      _userSuggestions = snapshot.docs
          .map((doc) => doc['UserName'] as String) // Map to UserName field
          .toList();
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
      // Save the post to Firestore
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

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );
      Navigator.pop(context);
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
                Navigator.pop(context); // Go back when "Cancel" is tapped
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.abhayaLibre(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Been There',
                style: GoogleFonts.abhayaLibre(
                  color: Colors.white,
                  fontSize: 36.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () => _savePost(context, user), // Save the post
              child: Text(
                'Save',
                style: GoogleFonts.abhayaLibre(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
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
                style: GoogleFonts.abhayaLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Location search field
              GestureDetector(
                onTap: () async {
                  Prediction? prediction = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: 'YOUR_GOOGLE_API_KEY',
                    mode: Mode.overlay, // Fullscreen overlay
                    language: 'en', // Language for results
                    components: [Component(Component.country, 'gr')], // Restrict to Greece
                  );

                  if (prediction != null) {
                    PlacesDetailsResponse detail = await GoogleMapsPlaces(
                      apiKey: 'YOUR_GOOGLE_API_KEY',
                    ).getDetailsByPlaceId(prediction.placeId!);

                    setState(() {
                      _location = prediction.description; // Place name
                      _latitude = detail.result.geometry!.location.lat;
                      _longitude = detail.result.geometry!.location.lng;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    _location ?? 'Search places or businesses',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description field
              TextField(
                onChanged: (value) => _description = value,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Tag friends field
              TextField(
                focusNode: _tagFieldFocusNode,
                onChanged: (value) => _fetchMatchingUsers(value), // Fetch users
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_add_alt),
                  hintText: 'Tag a friend',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Display user suggestions
              if(_showSuggestions)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _userSuggestions.length,
                  itemBuilder: (context, index) {
                    final user = _userSuggestions[index];
                    return ListTile(
                      title: Text(user),
                      onTap: () {
                        setState(() {
                          if (!_tags.contains(user)) {
                            _tags.add(user); // Add to tags
                          }
                          _showSuggestions = false; // Hide suggestions
                          _tagFieldFocusNode.unfocus(); // Remove focus from the text field
                        });
                      },
                    );
                  },
                ),

              // Display selected tags
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
                style: GoogleFonts.abhayaLibre(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
    );
  }
  
  @override
  void dispose() {
    _tagFieldFocusNode.dispose(); // Dispose of focus node to prevent memory leaks
    super.dispose();
  }
}