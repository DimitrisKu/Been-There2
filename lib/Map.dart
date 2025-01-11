import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Map_Widget extends StatefulWidget {
  @override
  _Map_WidgetState createState() => _Map_WidgetState();
}

class _Map_WidgetState extends State<Map_Widget> {
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.9429, 23.6463), // Default center (Piraeus, Greece)
    zoom: 12,
  );

  final Set<Marker> _markers = {}; // Set to hold markers dynamically
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _fetchMarkers(); // Fetch Firestore markers when the widget initializes
  }

  Future<void> _fetchMarkers() async {
    try {
      // Fetch all documents from the 'posts' collection
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if the 'coordinates' field exists and is valid
        if (data.containsKey('coordinates') &&
            data['coordinates'] is List &&
            data['coordinates'].length == 2) {
          final double latitude = double.tryParse(data['coordinates'][0].toString()) ?? 0.0;
          final double longitude = double.tryParse(data['coordinates'][1].toString()) ?? 0.0;

          // Add a marker for this post
          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: data['username'] ?? 'Unknown User',
              snippet: data['location'] ?? 'Unknown Location',
              onTap: () => _navigateToPostDetails(doc.id),
            ),
          );

          setState(() {
            _markers.add(marker); // Add the marker to the map
          });
        } else {
          print('Invalid or missing coordinates for document: ${doc.id}');
        }
      }
      print('Total markers added: ${_markers.length}');
    } catch (e) {
      print('Error fetching markers from Firestore: $e');
    }
  }

  void _navigateToPostDetails(String postId) {
    Navigator.pushNamed(
      context,
      '/postDetails',
      arguments: postId, // Pass the post ID to the details screen
    );
  }

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: mainAppBar(context, user),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        markers: _markers, // Display dynamic markers on the map
        onMapCreated: (controller) {
          _mapController = controller;
          _mapController.setMapStyle(_mapStyle); // Disable POIs
        },
      ),
      bottomNavigationBar: MapMenu(context, user),
    );
  }
}

// Disable POIs with this map style
const String _mapStyle = '''
[
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  }
]
''';
