import 'package:clone_whats_app/pages/chat_page.dart';
import 'package:clone_whats_app/pages/contacts_page.dart';
import 'package:clone_whats_app/utils/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clone_whats_app/pages/auth_page.dart';
import 'package:clone_whats_app/pages/home_page.dart';
import 'package:clone_whats_app/pages/loading_page.dart';
import 'package:clone_whats_app/pages/profile_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "whats up clone",
      routes: {
        "/": LoadingPage().build,
//        "/": (ctx) => Center(child: Text("wait")),
        "/auth": (ctx) => AuthPage(),
        "/home": (ctx) => HomePage(),
        "/profile": (ctx) => ProfilePage(),
        "/contacts": (ctx) => ContactsPage(),
        "/chat": (ctx) => ChatPage(),
      },
      theme: myTheme,
    );
  }

  final ThemeData myTheme = ThemeData(
    primarySwatch: Colors.green,
    textTheme: TextTheme(
      title: TextStyle(
        color: Colors.green,
      ),
      body1: TextStyle(
        fontSize: 18,
      ),
//          button: TextStyle(color: Colors.white)),
    ),
  );
}
