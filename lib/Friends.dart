
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
                Expanded(
                  child: One_Friend_List(
                    user: widget.user,
                  ), // Αντικατέστησε το `InfiniteList` με τη λίστα σου
                ), 
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
                Expanded(
                  child: Friend_Request_List(
                    user: widget.user,
                  ), // Αντικατέστησε το `InfiniteList` με τη λίστα σου
                ), 
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


class One_Friend_Request extends StatefulWidget {
  final String username;
  final String user;

  One_Friend_Request(
    {required this.username, required this.user}
  );
  
  @override
  One_Friend_Request_State createState() => One_Friend_Request_State();
}

class One_Friend_Request_State extends State<One_Friend_Request> {

  bool isProcessing = false; // Αποτρέπει πολλαπλά taps


  Future<void> decline_request() async {

    if (isProcessing) return; // Αν είναι ήδη σε εξέλιξη, δεν κάνουμε τίποτα

    setState(() {
      isProcessing = true;
    });

    final querySnap = await FirebaseFirestore.instance
      .collection('Users')
      .where('UserName', isEqualTo: widget.user)
      .get();

      if (querySnap.docs.isNotEmpty) {
        // Παίρνουμε το πρώτο έγγραφο από το αποτέλεσμα
        final userDoc = querySnap.docs.first.reference;

        // Εκτελούμε query στο subcollection "friend requests"
        final friendRequestSnap = await userDoc
            .collection('friend requests')
            .where('username', isEqualTo: widget.username)
            .get();

        if (friendRequestSnap.docs.isNotEmpty) {
          // Διαγραφή των εγγράφων που βρέθηκαν
          for (final doc in friendRequestSnap.docs) {
            await doc.reference.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have declined the friend request'))
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No friend request found'))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found'))
          );
      }

      setState(() {
        isProcessing = false;
      });

      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Friends_Widget(
                user: widget.user,
              ),
              )
            );

  }

  Future<void> accept_request() async {

    if (isProcessing) return; // Αν είναι ήδη σε εξέλιξη, δεν κάνουμε τίποτα

    setState(() {
      isProcessing = true;
    });

    
    // Add friend to username

    final querySnap2 = await FirebaseFirestore.instance
      .collection('Users')
      .where('UserName', isEqualTo: widget.username)
      .get();

      if (querySnap2.docs.isNotEmpty) {
        // Παίρνουμε το πρώτο έγγραφο από το αποτέλεσμα
        final userDoc = querySnap2.docs.first.reference;

        // Add friend to user
        final newDocRef = await userDoc.collection('friends').add({
          'username': widget.user, // Εισαγωγή πεδίων στο νέο έγγραφο
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found'))
          );
          return;
      }

    // Delete friend request
    final querySnap = await FirebaseFirestore.instance
      .collection('Users')
      .where('UserName', isEqualTo: widget.user)
      .get();

      if (querySnap.docs.isNotEmpty) {
        // Παίρνουμε το πρώτο έγγραφο από το αποτέλεσμα
        final userDoc = querySnap.docs.first.reference;

        // Add friend to user
        final newDocRef = await userDoc.collection('friends').add({
          'username': widget.username, // Εισαγωγή πεδίων στο νέο έγγραφο
        });

        // Εκτελούμε query στο subcollection "friend requests"
        final friendRequestSnap = await userDoc
            .collection('friend requests')
            .where('username', isEqualTo: widget.username)
            .get();

        if (friendRequestSnap.docs.isNotEmpty) {
          // Διαγραφή των εγγράφων που βρέθηκαν
          for (final doc in friendRequestSnap.docs) {
            await doc.reference.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have accepted the friend request'))
              );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No friend request found'))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found'))
          );
          return;
      }

      setState(() {
        isProcessing = false;
      });

      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Friends_Widget(
                user: widget.user,
              ),
              )
            );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Icon
          const CircleAvatar(
            radius: 25, // Μέγεθος του εικονιδίου
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.account_circle,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12), // Διάστημα ανάμεσα στο icon και στο username

          // Username
          Expanded(
            child: Text(
              widget.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Accept Button
          TextButton(
            onPressed: () {
              accept_request();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Accept'),
          ),
          const SizedBox(width: 8), // Διάστημα ανάμεσα στα κουμπιά

          // Decline Button
          TextButton(
            onPressed: () {
              decline_request();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

}


class Friend_Request_List extends StatefulWidget {
  final String user;

  Friend_Request_List(
    {required this.user}
  );
  
  @override
  Friend_Request_List_State createState() => Friend_Request_List_State();
}

class Friend_Request_List_State extends State<Friend_Request_List> {

  List<One_Friend_Request> comments = [];
  bool isLoading = false; 

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;


  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;  // Αν τα δεδομένα φορτώνουν ήδη, δεν κάνουμε τίποτα

    setState(() {
      isLoading = true;  // Ξεκινάμε τη φόρτωση δεδομένων
    });

    final querySnap = await FirebaseFirestore.instance
    .collection('Users')
    .where('UserName', isEqualTo: widget.user)
    .get(); // Εκτελείς το query

    final userDoc = querySnap.docs.first.reference; // Παίρνεις το DocumentReference του user μας
    
    Query query = userDoc
        .collection('friend requests')
        .orderBy('username')
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ενημερώνουμε το lastDocument με το τελευταίο document του query
      lastDocument = querySnapshot.docs.last;

      List<One_Friend_Request> newComments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return One_Friend_Request(
          username: data['username'],
          user: widget.user,
        );
      }).toList();
    

    await Future.delayed(Duration(seconds: 2));  // Προσομοίωση καθυστέρησης φόρτωσης

    setState(() {
      // Προσθήκη νέων δεδομένων στη λίστα
      comments.addAll(newComments);
      isLoading = false;  // Σταματάμε τη φόρτωση
    });
    } else {
      setState(() {
        hasMoreData = false; // Δεν υπάρχουν άλλα δεδομένα να φέρουμε
        isLoading = false;
      });
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
    TextEditingController _commentController = TextEditingController();

  return Stack(
    children: [
      // Scrollable περιεχόμενο
      ListView.builder(
        controller: _scrollController, // Σύνδεση του ScrollController
        itemCount: comments.length + 1, // Προσθήκη επιπλέον στοιχείου για τον progress indicator
        padding: EdgeInsets.only(bottom: 80), // Εξασφαλίζουμε χώρο για το TextBox
        itemBuilder: (context, index) {
          // Αν φτάσουμε στο τελευταίο στοιχείο, εμφανίζουμε το loading indicator
          if (index == comments.length) {
            if (!hasMoreData) {
              return Center(
                child: Text('NO MORE FRIEND REQUESTS'),
              );
            } else {
              return isLoading
                  ? Center(child: CircularProgressIndicator()) // Εμφανίζουμε το loading όταν φορτώνουμε
                  : SizedBox.shrink(); // Αν δεν φορτώνουμε, δεν εμφανίζουμε τίποτα
            }
          }
          return Column(
            children: [
              comments[index],
              SizedBox(height: 20), // Απόσταση μεταξύ των posts
            ],
          );
        },
      ),
      
    ],
  );
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Καθαρίζουμε τον ScrollController
    super.dispose();
  }

}


class One_Friend extends StatefulWidget {
  final String username;
  final String user;

  One_Friend(
    {required this.username, required this.user}
  );
  
  @override
  One_Friend_State createState() => One_Friend_State();
}

class One_Friend_State extends State<One_Friend> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Icon
          const CircleAvatar(
            radius: 25, // Μέγεθος του εικονιδίου
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.account_circle,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12), // Διάστημα ανάμεσα στο icon και στο username

          // Username
          Expanded(
            child: Text(
              widget.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class One_Friend_List extends StatefulWidget {
  final String user;

  One_Friend_List(
    {required this.user}
  );
  
  @override
  One_Friend_List_State createState() => One_Friend_List_State();
}

class One_Friend_List_State extends State<One_Friend_List> {

  List<One_Friend> comments = [];
  bool isLoading = false; 

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;


  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;  // Αν τα δεδομένα φορτώνουν ήδη, δεν κάνουμε τίποτα

    setState(() {
      isLoading = true;  // Ξεκινάμε τη φόρτωση δεδομένων
    });

    final querySnap = await FirebaseFirestore.instance
    .collection('Users')
    .where('UserName', isEqualTo: widget.user)
    .get(); // Εκτελείς το query

    final userDoc = querySnap.docs.first.reference; // Παίρνεις το DocumentReference του user μας
    
    Query query = userDoc
        .collection('friends')
        .orderBy('username')
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ενημερώνουμε το lastDocument με το τελευταίο document του query
      lastDocument = querySnapshot.docs.last;

      List<One_Friend> newComments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return One_Friend(
          username: data['username'],
          user: widget.user,
        );
      }).toList();
    

    await Future.delayed(Duration(seconds: 2));  // Προσομοίωση καθυστέρησης φόρτωσης

    setState(() {
      // Προσθήκη νέων δεδομένων στη λίστα
      comments.addAll(newComments);
      isLoading = false;  // Σταματάμε τη φόρτωση
    });
    } else {
      setState(() {
        hasMoreData = false; // Δεν υπάρχουν άλλα δεδομένα να φέρουμε
        isLoading = false;
      });
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
    TextEditingController _commentController = TextEditingController();

  return Stack(
    children: [
      // Scrollable περιεχόμενο
      ListView.builder(
        controller: _scrollController, // Σύνδεση του ScrollController
        itemCount: comments.length + 1, // Προσθήκη επιπλέον στοιχείου για τον progress indicator
        padding: EdgeInsets.only(bottom: 80), // Εξασφαλίζουμε χώρο για το TextBox
        itemBuilder: (context, index) {
          // Αν φτάσουμε στο τελευταίο στοιχείο, εμφανίζουμε το loading indicator
          if (index == comments.length) {
            if (!hasMoreData) {
              return Center(
                child: Text('YOU HAVE NO FRIENDS'),
              );
            } else {
              return isLoading
                  ? Center(child: CircularProgressIndicator()) // Εμφανίζουμε το loading όταν φορτώνουμε
                  : SizedBox.shrink(); // Αν δεν φορτώνουμε, δεν εμφανίζουμε τίποτα
            }
          }
          return Column(
            children: [
              comments[index],
              SizedBox(height: 20), // Απόσταση μεταξύ των posts
            ],
          );
        },
      ),
      
    ],
  );
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Καθαρίζουμε τον ScrollController
    super.dispose();
  }

}

