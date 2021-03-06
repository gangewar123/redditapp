import 'package:flutter/material.dart';
import 'package:redditapp/widget/reply_details.dart';
import 'widget/upload_details.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Reddit_app_demo',
        home: Reply(),
        // LoginScreen(),
        routes: <String, WidgetBuilder>{
          '/landingpage': (BuildContext context) => new MyApp(),
          '/signup': (BuildContext context) => new SignupScreen(),
          '/homepage': (BuildContext context) => new HomeScreen(),
          '/newsdetails': (BuildContext context) => new UploadScreen(),
        });
  }
}
