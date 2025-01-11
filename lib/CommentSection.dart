class Comment_List_State extends State<Comment_List> {
  List<Comment_Widget> comments = [];
  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastDocument;
  bool hasMoreData = true;

  LatLng? postCoordinates; // To store the coordinates of the post

  // Fetches the coordinates of the post
  Future<void> fetchPostCoordinates() async {
    try {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.PostID)
          .get();

      if (postSnapshot.exists) {
        Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
        if (postData['coordinates'] != null &&
            postData['coordinates'] is List &&
            postData['coordinates'].length == 2) {
          double latitude = double.parse(postData['coordinates'][0].toString());
          double longitude = double.parse(postData['coordinates'][1].toString());
          setState(() {
            postCoordinates = LatLng(latitude, longitude); // Store the coordinates
          });
          print('Post coordinates: $postCoordinates');
        } else {
          print('Invalid or missing coordinates for post: ${widget.PostID}');
        }
      } else {
        print('Post not found: ${widget.PostID}');
      }
    } catch (e) {
      print('Error fetching post coordinates: $e');
    }
  }

  Future<void> uploadComment(String com) async {
    try {
      CollectionReference commentsRef = FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.PostID)
          .collection('comments');

      await commentsRef.add({
        'username': widget.user,
        'comment': com,
        'date': FieldValue.serverTimestamp(),
      });

      print('Comment uploaded successfully!');
    } catch (e) {
      print('Failed to upload comment: $e');
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Comment_Section_Widget(
          user: widget.user,
          PostID: widget.PostID,
        ),
      ),
    );
  }

  Future<void> loadData() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.PostID)
        .collection('comments')
        .orderBy('date', descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;

      List<Comment_Widget> newComments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Comment_Widget(
          username: data['username'],
          comment: data['comment'],
          date: data['date'].toDate(),
        );
      }).toList();

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        comments.addAll(newComments);
        isLoading = false;
      });
    } else {
      setState(() {
        hasMoreData = false;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPostCoordinates(); // Fetch the coordinates of the post
    loadData();

    _scrollController.addListener(() {
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
        ListView.builder(
          controller: _scrollController,
          itemCount: comments.length + 1,
          padding: EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            if (index == comments.length) {
              if (!hasMoreData) {
                return Center(
                  child: Text('NO MORE COMMENTS'),
                );
              } else {
                return isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox.shrink();
              }
            }
            return Column(
              children: [
                comments[index],
                SizedBox(height: 20),
              ],
            );
          },
        ),
        if (postCoordinates != null)
          Positioned(
            top: 8.0,
            left: 16.0,
            child: Text(
              'Post Coordinates: ${postCoordinates!.latitude}, ${postCoordinates!.longitude}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
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
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    String newComment = _commentController.text.trim();
                    if (newComment.isNotEmpty) {
                      uploadComment(newComment);
                      _commentController.clear();
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
    _scrollController.dispose();
    super.dispose();
  }
}
