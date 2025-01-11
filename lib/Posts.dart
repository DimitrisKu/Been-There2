
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import'CommentSection.dart';
import 'OtherProfiles.dart';



Row StarRating(int rating) {
  switch (rating) {
    case 1:
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
        ],
      );

    case 2:
      return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
        ],
      );

    case 3:
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
        ],
      );

    case 4:
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star_border
          ),
        ],
      );

    case 5:
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
          Icon(
            Icons.star
          ),
        ],
      );

    default:
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
          Icon(
            Icons.star_border
          ),
        ],
      );
  }
}


class Post_Widget extends StatefulWidget {
  final String user;      //logged in user

  final String PostID;
  final String username;      //of the post
  final String location;
  final String description;
  final DateTime date;
  final int rating;

  Post_Widget(
    {required this.user, required this.username, required this.location, required this.description, required this.date, 
    required this.rating, required this.PostID}
    );

  @override
  Post_Widget_State createState() => Post_Widget_State();

}


class Post_Widget_State extends State<Post_Widget> {

  bool isLiked = false; // Ελέγχει αν ο τρέχων χρήστης έχει κάνει like
  int likeCount = 0; // Ο συνολικός αριθμός των likes
  bool isProcessing = false; // Αποτρέπει πολλαπλά taps

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
  }

  // Φόρτωση κατάστασης like από τη βάση δεδομένων
  Future<void> fetchLikeStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.PostID)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final likes = List<String>.from(data['likes'] ?? []);
      setState(() {
        isLiked = likes.contains(widget.user);
        likeCount = likes.length-1;
      });
    }
  }

  // Εναλλαγή κατάστασης like
  Future<void> toggleLike() async {
    if (isProcessing) return; // Αν είναι ήδη σε εξέλιξη, δεν κάνουμε τίποτα

    setState(() {
      isProcessing = true;
    });

    final postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.PostID);

    if (isLiked) {
      // Αν ο χρήστης έχει κάνει like, αφαιρούμε το like
      await postRef.update({
        'likes': FieldValue.arrayRemove([widget.user]),
      });
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      // Αν ο χρήστης δεν έχει κάνει like, προσθέτουμε το like
      await postRef.update({
        'likes': FieldValue.arrayUnion([widget.user]),
      });
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }

    setState(() {
      isProcessing = false; // Επιτρέπουμε ξανά τα taps
    });
  }

  OverlayEntry? _overlayEntry;

  void ShowFullDescription(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 4,
        left: MediaQuery.of(context).size.width / 8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.description,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _removeOverlay();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Εισαγωγή του OverlayEntry στο Overlay
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: Row(
                  children: [
                    IconButton(           // profile picture
                      icon: const Icon(
                        Icons.account_circle,
                        color: Colors.blueGrey,
                        size: 50,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OtherProfile_Widget(
                              username: widget.username,
                              user: widget.user,
                            )
                          )
                        );
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )
                          ),
                        Text(
                          widget.date.toString().substring(0, 16),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          ),
                        const Text(
                          'tags',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            widget.location,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )
                            ),
                        ),
                        StarRating(widget.rating),
                      ],
                    )
                  ],
                ),
              ),
              Padding(                          // Small description
                padding: EdgeInsets.all(10.0), // Padding γύρω από το στοιχείο
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Χρώμα του περιγράμματος
                      width: 2.0, // Πάχος του περιγράμματος
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Στρογγυλεμένες γωνίες
                  ),
                  child: TextButton(                    // small description
                    onPressed: () {
                      ShowFullDescription(context);
                    },
                    child: Text(
                      widget.description.substring(0, 35) + '...',
                      style: const TextStyle(
                                color: Colors.black
                              )
                      ),
                  )
                )
              ),
              Container(                // Photos
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Χρώμα του περιγράμματος
                    width: 2.0, // Πάχος του περιγράμματος
                  ),
                  borderRadius: BorderRadius.circular(12.0), // Στρογγυλεμένες γωνίες
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Ευθυγράμμιση με το περίγραμμα
                  child: Image.asset(
                    'assets/images/circles.png', // URL της εικόνας
                    fit: BoxFit.cover,
                  ),
                )
              ),
              Container(
                width: 300,
                child: Row(           // Likes, comments,         no of photos
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        toggleLike();
                      },
                    ),
                    Text('$likeCount'),
                    SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(
                        Icons.messenger_outline_rounded,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Comment_Section_Widget(
                              user: widget.user,
                              PostID: widget.PostID,
                            )
                          )
                        );
                      },
                    ),
                  ],
                )
            )
            ],
      );
      
  
  }

}
