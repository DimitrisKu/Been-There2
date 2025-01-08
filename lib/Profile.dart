
import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';


// Εδω εχουμε την οθονη του Profile
class Profile_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: mainAppBar(context, user),
        body: Center(child: Text(user),),
        bottomNavigationBar: ProfileMenu(context, user),
      );
  }

}

