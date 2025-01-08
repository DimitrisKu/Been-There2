
import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';

// Εδω εχουμε την οθονη του Map

class Map_Widget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: mainAppBar(context, user),
        bottomNavigationBar: MapMenu(context, user),
      );
  }

}

