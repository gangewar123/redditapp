import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();
  final String username;
  final String uid;
  final String avatarUrl;
  final String comment;
  final String timestamp;
  final String postId;
  final String commentId;

  Comment(
      {this.username,
      this.uid,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.postId,
      this.commentId});

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['username'],
      uid: document['uid'],
      comment: document["comment"],
      timestamp: document["timestamp"],
      avatarUrl: document["userImage"],
      postId: document['postId'],
      commentId: document['commentId'],
    );
  }

  Future<List<Widget>> getReplies(id, context) async {
    List<Widget> replies = [];
    MediaQueryData media = MediaQuery.of(context);
    QuerySnapshot data = await Firestore.instance
        .collection("Comments")
        .document(id)
        .collection("comments")
        .document(id)
        .collection("replies")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      print(
          "data added $uid.....${doc.data["postId"]}...${doc.data["userImage"]}");
      if (doc.data["commentId"] == commentId) {
        replies.add(
          Row(
            children: <Widget>[
              Container(
                color: Colors.white,
//      margin: EdgeInsets.all(2),
                width: media.size.width * 0.2,
                height: media.size.height * 0.14,

                child: VerticalDivider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
//        alignment: Alignment.center,
                      color: Colors.white,
//    margin: EdgeInsets.all(2),
                      width: media.size.width,
                      height: media.size.height * 0.14,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: media.size.width * 0.18,
                                height: media.size.height * 0.08,
//                  color: Colors.black12,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.black12,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: doc.data["userImage"] == null
                                            ? new NetworkImage(
                                                "https://carlisletheacarlisletheatre.org/images/icon-reddit-android-1.png")
                                            : new NetworkImage(
                                                "${doc.data["userImage"]}"))),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "$username",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                          left: 10,
                                          top: 10,
                                        ),
                                      ),
                                      Container(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Today at 5:42PM",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                          left: 8,
                                          top: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 8),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            doc.data["reply"],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 10,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // Container(
          //   child: new Text(doc.data["reply"]),
          // ),
        );
      }
    });

    return replies;
  }

  Widget buildReplies(context, id) {
    return FutureBuilder<List<Widget>>(
        future: getReplies(id, context),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                // height: 200,
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Container(
//        alignment: Alignment.center,
          color: Colors.white,
//    margin: EdgeInsets.all(2),
          width: media.size.width,
          // height: media.size.height * 0.14,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: media.size.width * 0.18,
                    height: media.size.height * 0.08,
//                  color: Colors.black12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey),
                        color: Colors.black12,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(avatarUrl))),
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "$username",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            margin: EdgeInsets.only(
                              left: 10,
                              top: 10,
                            ),
                          ),
                          Container(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Today at 5:42PM",
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 17),
                              ),
                            ),
                            margin: EdgeInsets.only(
                              left: 8,
                              top: 10,
                            ),
                          )
                        ],
                      ),
                      Wrap(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 8),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                comment,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: media.size.width * 0.2,
                    margin: EdgeInsets.only(right: 15),
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      _displayDialog(context);
                    },
                    child: Text(
                      "Reply",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Container(
                  // height: 200,
                  // width: 400,
                  color: Colors.blue[100],
                  child: buildReplies(context, postId)),
            ],
          ),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reply'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Type here.."),
            ),
            actions: <Widget>[
              new FlatButton(
                color: Colors.blue[800],
                child: new Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                color: Colors.blue[800],
                child: new Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Firestore.instance
                      .collection("Comments")
                      .document(postId)
                      .collection("comments")
                      .document(postId)
                      .collection("replies")
                      .add({
                    // "uid": widget.userId,
                    "reply": _textFieldController.text,
                    "timestamp": DateTime.now().toString(),
                    // "username": widget.userName,
                    "userImage": avatarUrl,
                    "postId": postId,
                    "commentId": commentId
                  });
                  // setState(() {
                  //   _controller.clear();
                  // });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
