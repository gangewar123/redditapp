import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:redditapp/widget/comment_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  List<DocumentSnapshot> documents;
  String userId;
  int index;
  String userImage;
  String userName;
  String postedImage;
  PostScreen(
      {this.documents,
      this.index,
      this.userId,
      this.userImage,
      this.userName,
      this.postedImage});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String postId;
  String image;
  String title;
  String description;
  String userName;
  String postedImage;

  TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var uuid = new Uuid();

    title = widget.documents[widget.index].data['title'].toString();
    description = widget.documents[widget.index].data['description'].toString();
    image = widget.documents[widget.index].data['uploaderImage'].toString();
    postId = widget.documents[widget.index].data['pid'].toString();
    postedImage = widget.documents[widget.index].data['postedImage'].toString();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: Colors.blue,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    postedImage,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Comments",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Center(
              child: Container(
                height: 1,
                width: media.size.width,
                color: Color(0xffa2a2a2),
              ),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(10.0), child: buildComments()),
            ),
            Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: "Post comment..",
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    hintStyle: new TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  autofocus: false,
                  onFieldSubmitted: (String item) {
                    Firestore.instance
                        .collection("Comments")
                        .document(postId)
                        .collection("comments")
                        .add({
                      "uid": widget.userId,
                      "comment": item,
                      "timestamp": DateTime.now().toString(),
                      "username": widget.userName,
                      "userImage": widget.userImage,
                      "postId": postId,
                      "commentId": uuid.v1(),
                    });
                    setState(() {
                      _controller.clear();
                    });
                  },
                )),
          ],
        ),
      )),
    );
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('global_user', widget.userName);
    prefs.setString('global_image', widget.userImage);
    QuerySnapshot data = await Firestore.instance
        .collection("Comments")
        .document(postId)
        .collection("comments")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });

    return comments;
  }

  Widget buildComments() {
    return FutureBuilder<List<Comment>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data,
          );
        });
  }
}
