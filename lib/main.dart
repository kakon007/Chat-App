import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/views/helper.dart';
import 'package:chat_app/views/signin-up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getuserLoggedIn().then((value) {
      // setState(() {
      //   userIsLoggedIn = value;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'ui',
      routes: {
        'start': (context) => MyApp(),
        'ui': (context) => UiDesign(),
        'chat': (context) => ChatRoom(),
      },
    );
  }
}
