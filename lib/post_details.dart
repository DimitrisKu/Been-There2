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
        body:  // Infinite Scrolling List
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

