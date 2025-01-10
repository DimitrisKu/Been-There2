
import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Εδω εχουμε την οθονη του Map

class Map_Widget extends StatelessWidget {
    final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example coordinates
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: mainAppBar(context, user),
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
           // Map controller setup
          },
        ),
        bottomNavigationBar: MapMenu(context, user),
      );
  }

}

