
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Menu.dart';
import 'AppBars.dart';
import 'Posts.dart';


// Εδω εχουμε την οθονη του Feed.
class Feed_Widget extends StatelessWidget {

  @override
  Widget build(BuildContext context, ) {

    final String user = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: mainAppBar(context, user),
        body: Post_List(
          user: user
        ),
        bottomNavigationBar: FeedMenu(context, user),
      );

  }

}


class Post_List extends StatefulWidget {
  final String user;
  Post_List(
    {required this.user}
    );

  @override
  Post_List_State createState() => Post_List_State();

}

class Post_List_State extends State<Post_List> {
  List<Post_Widget> posts = [];
  bool isLoading = false; 

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;

  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;  // Αν τα δεδομένα φορτώνουν ήδη, δεν κάνουμε τίποτα

    setState(() {
      isLoading = true;  // Ξεκινάμε τη φόρτωση δεδομένων
    });

    Query query = FirebaseFirestore.instance
        .collection('Posts')
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

