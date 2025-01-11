import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AppBars.dart';
import 'Menu.dart';

class CoordinatesMap extends StatefulWidget {

  CoordinatesMap();

  @override
  _CoordinatesMapState createState() => _CoordinatesMapState();
}

class _CoordinatesMapState extends State<CoordinatesMap> {
  final Set<Marker> _markers = {}; // Store the markers for the map
  bool isLoading = false;

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

      // Extract GeoPoints and add them as markers
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('coordinates') && data['coordinates'] is GeoPoint) {
          GeoPoint geoPoint = data['coordinates'];
          String username = data['username'] ?? 'Unknown';
          String comment = data['comment'] ?? '';

          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              infoWindow: InfoWindow(
                title: username,
                snippet: comment,
              ),
            ),
          );
        }
      }

      setState(() {
        isLoading = false; // Update UI after loading
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
    loadCoordinates();
  }

  @override
  Widget build(BuildContext context) {
     final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: mainAppBar(context, user), // Custom AppBar
      bottomNavigationBar: ProfileMenu(context, user), // Custom Bottom Navigation Bar
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              // Map controller for future interactions if needed
            },
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator()), // Show loading spinner
        ],
      ),
    );
  }
}


