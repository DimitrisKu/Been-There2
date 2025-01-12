import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'AppBars.dart';
import 'Menu.dart';
import 'PostsAtLocationScreen.dart';


class CoordinatesMap extends StatefulWidget {
  CoordinatesMap();

  @override
  _CoordinatesMapState createState() => _CoordinatesMapState();
}

class _CoordinatesMapState extends State<CoordinatesMap> {
  final Set<Marker> _markers = {}; // Store the markers for the map
  bool isLoading = false;
  String? _mapStyle; // Holds the custom map style string

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.9429, 23.6463), // Default location (Piraeus, Greece)
    zoom: 12,
  );

  Future<void> loadCoordinates() async {
  setState(() {
    isLoading = true;
  });

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .get();

    // Map to group posts by unique coordinates
    Map<LatLng, List<DocumentSnapshot>> groupedPosts = {};

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('coordinates') && data['coordinates'] is GeoPoint) {
        GeoPoint geoPoint = data['coordinates'];
        LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);

        // Group posts by their LatLng
        if (!groupedPosts.containsKey(latLng)) {
          groupedPosts[latLng] = [];
        }
        groupedPosts[latLng]!.add(doc);
      }
    }

    // Create a marker for each unique coordinate
    groupedPosts.forEach((latLng, posts) {
      String location = posts.first['location'] ?? 'Unknown Location'; // Use the location field of the first post

      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()), // Use LatLng as a unique marker ID
          position: latLng,
          icon: BitmapDescriptor.defaultMarker, // Use the default Google Maps pin
          infoWindow: InfoWindow(
            title: location,
            snippet: '${posts.length} post(s)', // Show the number of posts at this location
            onTap: () {
              // Navigate to a new screen with posts from this location
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostsAtLocationScreen(posts: posts),
                ),
              );
            },
          ),
        ),
      );
    });

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print('Failed to load markers: $e');
    setState(() {
      isLoading = false;
    });
  }
}




  @override
  void initState() {
    super.initState();

    // Load the custom map style
    rootBundle.loadString('assets/map_style.json').then((style) {
      setState(() {
        _mapStyle = style;
      });
    });

    loadCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: mainAppBar(context, user), // Custom AppBar
      bottomNavigationBar: MapMenu(context, user), // Custom Bottom Navigation Bar
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            style: _mapStyle, // Apply the custom map style
            onMapCreated: (GoogleMapController controller) {
              // Map initialization if needed
            },
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator()), // Show loading spinner
        ],
      ),
    );
  }
}
