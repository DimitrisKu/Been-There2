import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Posts.dart';


AppBar backAppBarOtherProfile(BuildContext context, String username) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 25
    ),
    backgroundColor: const Color(0xFF1A2642),
    title: Text(
            'Profile of user "$username"',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Abhaya Libre ExtraBold',
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
    centerTitle: true,
  );
}



// Εδω εχουμε την οθονη του Profile
class OtherProfile_Widget extends StatelessWidget {
  final String user;
  final String username;

  OtherProfile_Widget(
    {required this.username, required this.user}
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: backAppBarOtherProfile(context, username),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Ενέργεια για το κουμπί "Friends"
                        },
                        child: const Text(
                          "Friends",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add Friend Button
                Add_Friend_Button(user: user, username: username)
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
              username: username,
            ),
          ), 
          
        ],
      ),
      );
  }
}


class Add_Friend_Button extends StatefulWidget {

  final String user;
  final String username;

  Add_Friend_Button(
    {required this.user, required this.username}
  );

  @override
  Add_Friend_Button_State createState() => Add_Friend_Button_State();

}

class Add_Friend_Button_State extends State<Add_Friend_Button> {

  String state = 'None';
  bool isProcessing = false; // Αποτρέπει πολλαπλά taps

  @override
  void initState() {
    super.initState();
    fetchFriendStatus();
  }

  Future<void> fetchFriendStatus() async {

    final querySnap = await FirebaseFirestore.instance
    .collection('Users')
    .where('UserName', isEqualTo: widget.user)
    .get(); // Εκτελείς το query

    final userDoc = querySnap.docs.first.reference; // Παίρνεις το DocumentReference του user μας
    
    Query query = userDoc
        .collection('friends')
        .where('username', isEqualTo: widget.username);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        state = 'Friends';
      });
      return;
    }

    query = userDoc
        .collection('friend requests')
        .where('username', isEqualTo: widget.username);

    querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        state = 'Received';
      }); 
      return;
    }

    final querySnap2 = await FirebaseFirestore.instance
    .collection('Users')
    .where('UserName', isEqualTo: widget.username)
    .get(); // Εκτελείς το query

    final userDoc2 = querySnap2.docs.first.reference; // Παίρνεις το DocumentReference του username μας 

    query = userDoc2
        .collection('friend requests')
        .where('username', isEqualTo: widget.user);

    querySnapshot = await query.get();
    
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        state = 'Requested';
      }); 
      return;
    }

  }
  

  // Εναλλαγή κατάστασης like
  Future<void> toggleFriendStatus() async {
    if (isProcessing) return; // Αν είναι ήδη σε εξέλιξη, δεν κάνουμε τίποτα

    setState(() {
      isProcessing = true;
    });

    if(state == 'None') {
      final querySnap = await FirebaseFirestore.instance
      .collection('Users')
      .where('UserName', isEqualTo: widget.username)
      .get();

      if (querySnap.docs.isNotEmpty) {
        // Παίρνουμε το πρώτο έγγραφο από το αποτέλεσμα
        final userDoc = querySnap.docs.first.reference;

        // Πρόσβαση στο subcollection και δημιουργία ενός νέου εγγράφου
        final newDocRef = await userDoc.collection('friend requests').add({
          'username': widget.user, // Εισαγωγή πεδίων στο νέο έγγραφο
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The friend request had been sent'))
          );

      } else {
        print("Failed to send the friend request");
      }

      setState(() {
        state = 'Requested';
      });

    }
    else if(state == 'Requested') {

    }
    else if(state == 'Friends') {

    }
    else if(state == 'Received') {

    }

    setState(() {
      isProcessing = false; // Επιτρέπουμε ξανά τα taps
    });
  }


  @override
  Widget build(BuildContext context) {
    if(state == 'None') {
      return TextButton(
                  onPressed: () {
                    // Ενέργεια για το κουμπί "Add Friend"
                    toggleFriendStatus();
                  },
                  child: const Text(
                    "Add Friend",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
              );
      }
    else if(state == 'Requested') {
      return TextButton(
                  onPressed: () {
                    // Ενέργεια για το κουμπί "Add Friend"
                    toggleFriendStatus();
                  },
                  child: const Text(
                    "Request has\nbeen sent",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
              ); 

    }
    else if(state == 'Friends') {
      return TextButton(
                  onPressed: () {
                    // Ενέργεια για το κουμπί "Add Friend"
                    toggleFriendStatus();
                  },
                  child: const Text(
                    "Friends",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              );

    }
    else if(state == 'Received') {
      return TextButton(
                  onPressed: () {
                    // Ενέργεια για το κουμπί "Add Friend"
                    toggleFriendStatus();
                  },
                  child: const Text(
                    "User has already\nsent you a\nrequest",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
              );
    }
    else {
      return Container();
    }
  }

}



class Post_List_OtherProfile extends StatefulWidget {
  final String user;
  final String username;
  Post_List_OtherProfile(
    {required this.user, required this.username}
    );

  @override
  Post_List_OtherProfile_State createState() => Post_List_OtherProfile_State();

}

class Post_List_OtherProfile_State extends State<Post_List_OtherProfile> {
  List<Post_Widget> posts = [];
  bool isLoading = false; 

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;

  Future<void> loadData() async {
    try {
    if (isLoading || !hasMoreData) return;  // Αν τα δεδομένα φορτώνουν ήδη, δεν κάνουμε τίποτα

    setState(() {
      isLoading = true;  // Ξεκινάμε τη φόρτωση δεδομένων
    });
    
    Query query = FirebaseFirestore.instance
        .collection('Posts')
        .where('username', isEqualTo: widget.username)
        .orderBy('date', descending: true)
        .limit(2);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ενημερώνουμε το lastDocument με το τελευταίο document του query
      lastDocument = querySnapshot.docs.last;

      List<Post_Widget> newPosts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post_Widget(
          username: data['username'],
          location: data['location'],
          description: data['description'],
          date: data['date'].toDate(),
          rating: data['rating'],
          user: widget.user,
          PostID: doc.id,
        );
      }).toList();
    

    await Future.delayed(Duration(seconds: 2));  // Προσομοίωση καθυστέρησης φόρτωσης

    setState(() {
      // Προσθήκη νέων δεδομένων στη λίστα
      posts.addAll(newPosts);
      isLoading = false;  // Σταματάμε τη φόρτωση
    });
    } else {
      setState(() {
        hasMoreData = false; // Δεν υπάρχουν άλλα δεδομένα να φέρουμε
        isLoading = false;
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Σφάλμα κατά τη διαγραφή: $e')),
    );
  }
  }

  @override
  void initState() {
    super.initState();
    loadData();

    _scrollController.addListener(() {
      // Όταν φτάσουμε στο τέλος της λίστας, φορτώνουμε περισσότερα δεδομένα
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,  // Σύνδεση του ScrollController
      itemCount: posts.length + 1,  // Προσθήκη επιπλέον στοιχείου για τον progress indicator
      itemBuilder: (context, index) {
        // Αν φτάσουμε στο τελευταίο στοιχείο, εμφανίζουμε το loading indicator
        if (index == posts.length) {
          if(!hasMoreData){
            return Text('NO MORE POSTS');
          }
          else {
            return isLoading 
            ? Center(child: CircularProgressIndicator())  // Εμφανίζουμε το loading όταν φορτώνουμε
            : SizedBox.shrink();  // Αν δεν φορτώνουμε, δεν εμφανίζουμε τίποτα
          }
        }
        return Column(
                children: [
                  posts[index],
                  SizedBox(height: 20),  // Απόσταση μεταξύ των posts
                ],
              );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Καθαρίζουμε τον ScrollController
    super.dispose();
  }
}

