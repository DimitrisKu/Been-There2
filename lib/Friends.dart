
import 'package:flutter/material.dart';
import 'AppBars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OtherProfiles.dart';


class Friends_Widget extends StatelessWidget {

  String user;

  Friends_Widget(
    {required this.user}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context, user),
      body: Friends_Widget_Body(
        user: user
        ),
    );
  }

}


class Friends_Widget_Body extends StatefulWidget {
  final String user;

  Friends_Widget_Body(
    {required this.user}
  );

  @override
  Friends_Widget_Body_State createState() => Friends_Widget_Body_State();
}

class Friends_Widget_Body_State extends State<Friends_Widget_Body> {

  String state = 'My Friends';

  @override
  Widget build(BuildContext context) {
    if(state == 'My Friends') { return My_Friends(); }
    else if(state == 'Friend Requests') { return Friend_Requests(); }
    else if(state == 'Search User') { return Search_User(); }
    else { return Container(); }
    }


    Widget My_Friends() {
      return Column(
              children: [
                // Row με TextButtons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το πρώτο κουμπί
                          setState(() {
                            state = 'My Friends';
                          });
                        },
                        child: const Text(
                          'My Friends',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            state = 'Friend Requests';
                          });
                        },
                        child: const Text(
                          'Friend Requests',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το τρίτο κουμπί
                          setState(() {
                            state = 'Search User';
                          });
                        },
                        child: const Text(
                          'Search User',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),

                // Χώρος για infinite list
          /*      Expanded(
                  child: InfiniteList(), // Αντικατέστησε το `InfiniteList` με τη λίστα σου
                ), */
              ],
            );
    }

    Widget Friend_Requests() {
          return Column(
              children: [
                // Row με TextButtons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το πρώτο κουμπί
                          setState(() {
                            state = 'My Friends';
                          });
                        },
                        child: const Text(
                          'My Friends',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το δεύτερο κουμπί
                          setState(() {
                            state = 'Friend Requests';
                          });
                        },
                        child: const Text(
                          'Friend Requests',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το τρίτο κουμπί
                          setState(() {
                            state = 'Search User';
                          });
                        },
                        child: const Text(
                          'Search User',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),

                // Χώρος για infinite list
          /*      Expanded(
                  child: InfiniteList(), // Αντικατέστησε το `InfiniteList` με τη λίστα σου
                ), */
              ],
            );
        }

    Widget Search_User() {

      TextEditingController searchController = TextEditingController();

      return Column(
              children: [
                // Row με TextButtons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το πρώτο κουμπί
                          setState(() {
                            state = 'My Friends';
                          });
                        },
                        child: const Text(
                          'My Friends',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το δεύτερο κουμπί
                          setState(() {
                            state = 'Friend Requests';
                          });
                        },
                        child: const Text(
                          'Friend Requests',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το τρίτο κουμπί
                          setState(() {
                            state = 'Search User';
                          });
                        },
                        child: const Text(
                          'Search User',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter username to search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                // Search User κουμπί
                ElevatedButton(
                  onPressed: () {
                    String username = searchController.text;
                    if (username.isNotEmpty) {
                      // Ενέργεια για το κουμπί αναζήτησης
                      Search_User_Func(username);
                    } else {
                      // Εμφάνιση μηνύματος αν το πεδίο είναι κενό
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('The search box cannot be empty'))
                        );
                    }
                  },
                  child: const Text('Search User'),
                ),
              ],
            );
        }


  Future<void> Search_User_Func(String username) async {

      Query query = FirebaseFirestore.instance
        .collection('Users')
        .where('UserName', isEqualTo: username);

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtherProfile_Widget(
              user: widget.user,
              username: username,
            )
          )
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This user does not exist'))
        );
      }

    }


}


