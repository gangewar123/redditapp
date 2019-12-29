import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class UserManagement {
  storeNewUser(_displayName, _phoneNumber, user,_path, context) {
    Firestore.instance.collection('/users').add({
      // Firestore.instance.collection('/News_Feed').document(user.email).collection(user.email).add({
      'uid': user.uid + user.email,
      'email': user.email,
      'displayName': _displayName,
      'phoneNumber': _phoneNumber,
      'userImage': _path
    }).then((value) {
      Navigator.of(context).pop();
       Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
      Navigator.of(context).pushReplacementNamed('/landingpage');
    }).catchError((e) {
      print(e);
    });
  }
}
