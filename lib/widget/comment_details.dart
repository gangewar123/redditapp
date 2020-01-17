import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Comment extends StatefulWidget {
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

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController _textFieldController = TextEditingController();

  bool onliked = false;
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
      if (doc.data["commentId"] == widget.commentId) {
        replies.add(
          Row(
            children: <Widget>[
              Container(
                color: Colors.white,
                width: 80,
                height: 80,
                child: VerticalDivider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: media.size.width,
                      height: 80,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: media.size.width * 0.15,
                                height: media.size.height * 0.05,
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
                                margin: EdgeInsets.only(right: 10, top: 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "${doc.data["username"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
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
                                                fontSize: 10),
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
                                              fontSize: 12,
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
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _displayReplyDialog(context);
                                  },
                                  child: Text(
                                    "Reply",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () {
                                //     setState(() => onliked = !onliked);
                                //   },
                                //   icon: onliked
                                //       ? Icon(
                                //           Icons.thumb_up,
                                //           color: Colors.blue,
                                //         )
                                //       : Icon(
                                //           Icons.thumb_down,
                                //           color: Colors.black,
                                //         ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    });

    return replies;
  }

  Future<List<Widget>> getMultiReplies(id, context) async {
    final prefs = await SharedPreferences.getInstance();
    var replyID = prefs.getString('replyId') ?? '';
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
      if (doc.data["replyId"] == replyID) {
        replies.add(
          Row(
            children: <Widget>[
              Container(
                color: Colors.white,
                width: 80,
                height: 80,
                child: VerticalDivider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: media.size.width,
                      height: 80,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: media.size.width * 0.15,
                                height: media.size.height * 0.05,
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
                                margin: EdgeInsets.only(right: 10, top: 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                           child: Text(
                                            "${doc.data["username"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
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
                                                fontSize: 10),
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
                                              fontSize: 12,
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
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _displayReplyDialog(context);
                                  },
                                  child: Text(
                                    "Reply",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
                padding: EdgeInsets.only(left: 10),
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data,
            ),
          );
        });
  }

  Widget buildMultiReplies(context, id) {
    return FutureBuilder<List<Widget>>(
        future: getMultiReplies(id, context),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                padding: EdgeInsets.only(left: 10),
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: media.size.width,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: media.size.width * 0.18,
                    height: media.size.height * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey),
                        color: Colors.black12,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(widget.avatarUrl))),
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "${widget.username}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
                                    TextStyle(color: Colors.grey, fontSize: 14),
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
                                widget.comment,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                style: TextStyle(
                                  fontSize: 16,
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
                    onPressed: () {
                      setState(() => onliked = !onliked);
                    },
                    icon: onliked
                        ? Icon(
                            Icons.thumb_up,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.thumb_down,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
              Container(
                  color: Colors.blue[100],
                  child: buildMultiReplies(context, widget.postId)),
            ],
          ),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    var uuid = new Uuid();
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
                  final prefs = await SharedPreferences.getInstance();
                  var replyName = prefs.getString('global_user') ?? '';
                  var replyImage = prefs.getString('global_image') ?? '';
                  var replyId = prefs.setString("replyId", uuid.v1());
                  var getReply = prefs.getString('replyId') ?? '';

                  print("the data off reply Id is $getReply");
                  Firestore.instance
                      .collection("Comments")
                      .document(widget.postId)
                      .collection("comments")
                      .document(widget.postId)
                      .collection("replies")
                      .add({
                    "reply": _textFieldController.text,
                    "timestamp": DateTime.now().toString(),
                    "username": replyName,
                    "userImage": replyImage,
                    "postId": widget.postId,
                    "commentId": widget.commentId,
                    "replyId": replyId,
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayReplyDialog(BuildContext context) async {
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
                  final prefs = await SharedPreferences.getInstance();
                  var replyName = prefs.getString('global_user') ?? '';
                  var replyImage = prefs.getString('global_image') ?? '';
                  Firestore.instance
                      .collection("Comments")
                      .document(widget.postId)
                      .collection("comments")
                      .document(widget.postId)
                      .collection("replies")
                      .add({
                    "reply": _textFieldController.text,
                    "timestamp": DateTime.now().toString(),
                    "username": replyName,
                    "userImage": replyImage,
                    "postId": widget.postId,
                    "commentId": widget.commentId
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
