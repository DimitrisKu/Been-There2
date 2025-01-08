
import 'package:flutter/material.dart';
import 'Notifications.dart';

// Σε αυτο το αρχειο εχουμε βαλει ολα τα AppBars της εφαρμογης. Εδω γινονται τα navigation για το save new post και για το notifications.

AppBar mainAppBar(BuildContext context, String user) {
  return AppBar(
    backgroundColor: const Color(0xFF1A2642),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.mic,
            color: Colors.white
          ),
          onPressed: () {
            // Ενέργεια για το mic button
          },
        ),
        const Expanded(
          child: Text(
            'Been There',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Abhaya Libre ExtraBold',
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Notification_Widget(),
                settings: RouteSettings(arguments: user)
              )
            );
          },
        ),
      ],
    ),
  );
}


AppBar backAppBar(BuildContext context, String user) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 25
    ),
    backgroundColor: const Color(0xFF1A2642),
    title: const Text(
            'Been There',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Abhaya Libre ExtraBold',
              fontSize: 36.0,
            ),
            textAlign: TextAlign.center,
          ),
    centerTitle: true,
  );
}


AppBar saveAppBar(BuildContext context, String user) {
  return AppBar(
    backgroundColor: const Color(0xFF1A2642),
    title: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Cancel',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 16.0, 
          )          
        ),
        const Expanded(
          child: Text(
            'Been There',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Abhaya Libre ExtraBold',
              fontSize: 36.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Text(
          'Save',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 16.0, 
          )          
        ),
      ],
    ),
  );
}

