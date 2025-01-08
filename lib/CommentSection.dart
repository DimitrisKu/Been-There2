
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

AppBar backAppBarComments(BuildContext context) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 25
    ),
    backgroundColor: const Color(0xFF1A2642),
    title: const Text(
            'Comments',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Abhaya Libre ExtraBold',
              fontSize: 36.0,
            ),
            textAlign: TextAlign.center,
          ),
    centerTitle: true,
  );
}

class Comment_Widget extends StatefulWidget {
  final String username;
  final String comment;
  final DateTime date;

  Comment_Widget(
    {required this.username, required this.comment, required this.date}
  );
  
  @override
  Comment_Widget_State createState() => Comment_Widget_State();
}

class Comment_Widget_State extends State<Comment_Widget> {

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Εικονίδιο λογαριασμού
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.blueGrey,
            size: 50,
          ),
          onPressed: () {
            // Ενέργεια για το κουμπί
          },
        ),
        const SizedBox(width: 8), // Διάστημα ανάμεσα στα στοιχεία
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Όνομα χρήστη
              Text(
                widget.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4), // Διάστημα μεταξύ του ονόματος και του σχολίου
              // Σχόλιο
              Text(
                widget.comment,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Ημερομηνία δημιουργίας του σχολίου
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.date.toString().substring(0, 16), // Φόρματ της ημερομηνίας
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}




class Comment_Section_Widget extends StatefulWidget {
  final String user;
  final String PostID;

  Comment_Section_Widget(
    {required this.user, required this.PostID}
  );

  @override
  Comment_Section_Widget_State createState() => Comment_Section_Widget_State();
}

class Comment_Section_Widget_State extends State<Comment_Section_Widget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBarComments(context),
      body: Comment_List(
        user: widget.user,
        PostID: widget.PostID,
      ),
    );
  }

}


class Comment_List extends StatefulWidget {
  final String user;
  final String PostID;
  Comment_List(
    {required this.user, required this.PostID}
    );

  @override
  Comment_List_State createState() => Comment_List_State();

}

class Comment_List_State extends State<Comment_List> {
  List<Comment_Widget> comments = [];
  bool isLoading = false; 

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;


Future<void> uploadComment(String com) async {
  try {
    // Δημιουργία αναφοράς στη συλλογή "comments"
    CollectionReference commentsRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.PostID).collection('comments');

    // Δημιουργία σχολίου
    await commentsRef.add({
      'username': widget.user, // Αναφορά στον χρήστη
      'comment': com, // Περιεχόμενο σχολίου
      'date': FieldValue.serverTimestamp(), // Χρόνος δημιουργίας
    });

    print('Comment uploaded successfully!');
  } catch (e) {
    print('Failed to upload comment: $e');
    // Διαχείριση σφαλμάτων
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Comment_Section_Widget(user: widget.user, PostID: widget.PostID))
  );
}


  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;  // Αν τα δεδομένα φορτώνουν ήδη, δεν κάνουμε τίποτα

    setState(() {
      isLoading = true;  // Ξεκινάμε τη φόρτωση δεδομένων
    });

    Query query = FirebaseFirestore.instance
        .collection('Posts').doc(widget.PostID).collection('comments')
        .orderBy('date', descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ενημερώνουμε το lastDocument με το τελευταίο document του query
      lastDocument = querySnapshot.docs.last;

      List<Comment_Widget> newComments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Comment_Widget(
          username: data['username'],
          comment: data['comment'],
          date: data['date'].toDate(),
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
                child: Text('NO MORE COMMENTS'),
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
      // Σταθερό TextBox και κουμπί
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              // TextBox για το σχόλιο
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8), // Απόσταση από το κουμπί
              // Κουμπί Upload
              ElevatedButton(
                onPressed: () {
                  // Δράση όταν πατηθεί το κουμπί
                  String newComment = _commentController.text.trim();
                  if (newComment.isNotEmpty) {
                    uploadComment(newComment);
                    _commentController.clear(); // Καθαρισμός του TextBox
                  }
                },
                child: Text("Upload"),
              ),
            ],
          ),
        ),
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


