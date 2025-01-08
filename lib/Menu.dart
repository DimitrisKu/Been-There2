
import 'NewPost.dart';
import 'Profile.dart';
import 'package:flutter/material.dart';
import 'Map.dart';
import 'Feed.dart';

// Σε αυτο το αρχειο εχουμe βαλει ολα τα μενου πλοηγησης της εφαρμογης. Μεσω αυτων γινεται η ολη διαδικασια πλοηγησης και εδω πρεπει να
// υλοποιηθουν ολες οι συναρτησεις του navigation.

BottomAppBar FeedMenu(BuildContext context, String user) {
  return BottomAppBar(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.sentiment_very_satisfied,
            color: Colors.black,
            size: 50,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Map_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewPost_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
      ],
    ),
  );
}


BottomAppBar MapMenu(BuildContext context, String user) {
  return BottomAppBar(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.sentiment_very_satisfied,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Feed_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
            size: 50,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewPost_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
      ],
    ),
  );
}


BottomAppBar NewPostMenu(BuildContext context, String user) {
  return BottomAppBar(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.sentiment_very_satisfied,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Feed_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Map_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.black,
            size: 50,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
      ],
    ),
  );
}


BottomAppBar ProfileMenu(BuildContext context, String user) {
  return BottomAppBar(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.sentiment_very_satisfied,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Feed_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Map_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 50,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewPost_Widget(),
              settings: RouteSettings(arguments: user),),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.black,
            size: 50,
          ),
          onPressed: () {

          },
        ),
      ],
    ),
  );
}


