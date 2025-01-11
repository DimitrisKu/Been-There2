
import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'Menu.dart';
import 'OtherProfiles.dart';
import 'login_screen.dart';
import 'Friends.dart';


// Εδω εχουμε την οθονη του Profile
class Profile_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: mainAppBar(context, user),
        body: Column(
        children: [
          // My Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Icon
                const CircleAvatar(
                  radius: 40, // Μεγαλούτσικο μέγεθος
                  backgroundColor: Colors.blueGrey,
                  child: Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                // Friends Count and Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "25", // Αριθμός φίλων
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το κουμπί "Friends"
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Friends_Widget(
                                  user: user,
                                )
                              )
                            );
                        },
                        child: const Text(
                          "Friends",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                // Logout and Search Icons
                Row(
                  children: [
                    
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Διαχωριστική γραμμή
          Divider(
            color: Colors.grey.shade400,
            thickness: 1.5, // Πιο φανερή γραμμή
            height: 1,
          ),

          // Infinite Scrolling List
          Expanded(
            child: Post_List_OtherProfile(
              user: user,
              username: user,
            ), 
          ),
        ],
      ),
        bottomNavigationBar: ProfileMenu(context, user),
      );
  }




}

