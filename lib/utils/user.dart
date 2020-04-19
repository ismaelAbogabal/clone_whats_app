import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class User {
  String id, name, bio, phone, imageUrl;

  User({
    this.name,
    this.imageUrl,
    this.bio,
    this.phone,
    this.id,
  });

  User.fromMap(Map<String, dynamic> data) {
    this.id = data["id"];
    this.imageUrl = data["imageUrl"];
    this.phone = data["phone"];
    this.bio = data["bio"];
    this.name = data["name"];
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "bio": bio,
      "imageUrl": imageUrl,
      "phone": phone,
    };
  }

  static Future<User> getUserData(String id) async {
    Query reference = FirebaseDatabase.instance.reference().child("users/$id");

    DataSnapshot snapshot = await reference.once();
    return User.fromMap(Map.from(snapshot.value));
  }

  static Future<User> getUserDataByPhone(String phoneNumber) async {
    Query reference = FirebaseDatabase.instance
        .reference()
        .child("users/")
        .orderByChild("phone")
        .equalTo("${phoneNumber.replaceAll("+", "")}");

    DataSnapshot snapshot = await reference.once();
    if (snapshot.value == null)
      return null;
    else
      return User.fromMap(
        Map.from(
          (snapshot.value as Map<dynamic, dynamic>).values.toList()[0],
        ),
      );
  }

  Future<void> updateUserData() {
    return FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(id)
        .update(toMap());
  }

  bool hasImage() {
    return imageUrl != null;
  }
}
