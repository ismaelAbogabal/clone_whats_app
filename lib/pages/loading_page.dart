import 'package:clone_whats_app/firebase/aut_utils.dart';
import 'package:clone_whats_app/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    moveToNext(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: FlatButton(
              child: Text("log out"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                moveToNext(context);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: FractionallySizedBox(
                heightFactor: .5,
                widthFactor: .5,
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
          ),
          Text("from"),
          SizedBox(height: 5),
          Text(
            "Ismael Abogabal".toUpperCase(),
            style: TextStyle(
              color: Colors.green[400],
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  void moveToNext(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    FirebaseAuth.instance.currentUser().then((user) async {
      if (user == null) {
        print("user == null ");
        Navigator.of(context).pushReplacementNamed("/auth");
      } else {
        cUser = await User.getUserData(user.uid);
        Navigator.pushReplacementNamed(context, "/home");
      }
    }).catchError((err) {
      Navigator.of(context).pushReplacementNamed("/auth");
    });
  }
}
