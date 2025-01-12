import 'package:flutter/material.dart';
import 'Notifications.dart';
import 'package:google_fonts/google_fonts.dart'; // Προσθήκη του Google Fonts
import 'Feed.dart';
import 'NewPost.dart';

// Στην παρακάτω συνάρτηση χρησιμοποιούμε τη γραμματοσειρά Abhaya Libre για τον τίτλο Been There
AppBar mainAppBar(BuildContext context, String user) {
  return AppBar(
    backgroundColor: const Color(0xFF1A2642),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.mic, color: Colors.white),
          onPressed: () {
            // Ενέργεια για το mic button
          },
        ),
        Expanded(
          child: Text(
            'Been There',
            style: GoogleFonts.abhayaLibre(
              // Χρησιμοποιούμε την γραμματοσειρά Abhaya Libre
              color: Colors.white,
              fontSize: 36.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Notification_Widget(),
              settings: RouteSettings(arguments: user),
            ));
          },
        ),
      ],
    ),
  );
}

AppBar backAppBar(BuildContext context, String user) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white, size: 25),
    backgroundColor: const Color(0xFF1A2642),
    title: Text(
      'Been There',
      style: GoogleFonts.abhayaLibre(
        // Χρησιμοποιούμε την γραμματοσειρά Abhaya Libre
        color: Colors.white,
        fontSize: 36.0,
      ),
      textAlign: TextAlign.center,
    ),
    centerTitle: true,
  );
}

AppBar saveAppBar(BuildContext context, String user, VoidCallback onPressed) {
  return AppBar(
    backgroundColor: const Color(0xFF1A2642),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Feed_Widget(),
                settings: RouteSettings(arguments: user),
              ),
            );
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
          onPressed: onPressed, // Use the callback passed from NewPost_Widget
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
  );
}
