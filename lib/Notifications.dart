
import 'package:flutter/material.dart';
import 'AppBars.dart';


// Εδω εχουμε την οθονη του Notifications
class Notification_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: backAppBar(context, user),
      );
  }

}

