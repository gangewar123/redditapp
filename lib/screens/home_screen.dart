import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redditapp/screens/post_screen.dart';
import 'package:redditapp/screens/upload_screen.dart';

class HomeScreen extends StatefulWidget {
  String email;
  String userImage;
  HomeScreen({this.email, this.userImage});
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String userName;
  String userImage;
  @override
  initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .where("email", isEqualTo: widget.email)
        .snapshots()
        .listen((onData) {
      setState(() {
        userImage = onData.documents[0].data['userImage'];
        userName = onData.documents[0].data['displayName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[200],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(userName ?? ''),
              accountEmail: new Text(widget.email ?? ''),
              decoration: new BoxDecoration(
                color: Colors.blue[800],
              ),
              currentAccountPicture:
                  CircleAvatar(backgroundImage: NetworkImage(userImage ?? '')),
            ),
            new ListTile(
                leading: Icon(Icons.apps),
                title: new Text("Apps"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.dashboard),
                title: new Text("Docs"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.settings),
                title: new Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.info),
                title: new Text("About"),
                onTap: () {
                  Navigator.pop(context);
                }),
            new ListTile(
                leading: Icon(Icons.power_settings_new),
                title: new Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
      appBar: AppBar(
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Text(userName ?? '')),
      body: _buildBody(context, widget.email),
    );
  }

  Widget _buildBody(BuildContext context, String email) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('News_Feed').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return FirestoreListView(
            documents: snapshot.data.documents, email: email);
      },
    );
  }
}

class FirestoreListView extends StatefulWidget {
  List<DocumentSnapshot> documents;
  String email;

  FirestoreListView({this.documents, this.email});

  @override
  FirestoreListViewState createState() {
    return new FirestoreListViewState();
  }
}

class FirestoreListViewState extends State<FirestoreListView> {
  String image;
  String userId;
  String userImage;
  String userName;
  bool liked = false;
  int likes = 0;
  var userInfo;
  // List<Comment> comments = [];

  @override
  initState() {
    super.initState();
    Firestore.instance
        .collection('users')
        .where("email", isEqualTo: widget.email)
        .snapshots()
        .listen((onData) {
      setState(() {
        userInfo = onData;
        userImage = onData.documents[0].data['userImage'];
        userName = onData.documents[0].data['displayName'];
        userId = onData.documents[0].data['uid'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent[400],
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadScreen(
                    documents: widget.documents, email: widget.email)),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        color: Colors.blue[100],
        child: ListView.builder(
            itemCount: widget.documents.length,
            itemExtent: media.size.height * .5,
            itemBuilder: (BuildContext context, int index) {
              String title = widget.documents[index].data['title'].toString();
              String description =
                  widget.documents[index].data['description'].toString();
              String image =
                  widget.documents[index].data['uploaderImage'].toString();
              String postedImage =
                  widget.documents[index].data['postedImage'].toString();
              String name = widget.documents[index].data['username'].toString();
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 23.0,
                        backgroundImage: NetworkImage(image),
                      ),
                      title: Container(
                          padding: EdgeInsets.only(left: 15),
                          width: media.size.width * .5,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostScreen(
                                  documents: widget.documents,
                                  index: index,
                                  userImage: userImage,
                                  userName: userName,
                                  userId: userId)),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: media.size.width,
                      height: 500,
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostScreen(
                                    documents: widget.documents,
                                    index: index,
                                    userImage: userImage,
                                    userName: userName,
                                    userId: userId)),
                          );
                        },
                        child: Container(
                          width: media.size.width * .23,
                          height: media.size.height * .12,
                          alignment: FractionalOffset.center,
                          decoration: new BoxDecoration(
                              color: const Color.fromRGBO(247, 64, 106, 1.0),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(5.0)),
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(postedImage))),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
