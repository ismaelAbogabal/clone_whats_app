import 'package:firebase_database/firebase_database.dart';

class SimpleChat {
  String id, name, lastMessage;

  SimpleChat({this.name, this.id, this.lastMessage});

  Future<List> users() {
    return FirebaseDatabase.instance
        .reference()
        .child("chats/$id/users")
        .once()
        .then(
      (val) {
        return val.value;
      },
    );
  }
}
