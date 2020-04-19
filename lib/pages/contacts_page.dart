import 'package:clone_whats_app/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<User> contacts = [];

  bool loading = true;

  _getContact() async {
    setState(() {
      loading = true;
    });
    await Permission.contacts.request();
    if (await Permission.contacts.isGranted) {
      ContactsService.getContacts().then((val) {
        val.forEach((Contact c) {
          c.phones.toList().forEach((number) async {
            User u = await User.getUserDataByPhone(number.value);
            if (u != null) {
              setState(() {
                contacts.add(u);
                loading = false;
              });
            }
          });
        });
      });
      setState(() {
        loading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("new Chat"),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemBuilder: _buildContact,
            itemCount: contacts.length,
          ),
          if (loading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context, int index) {
    User cUser = contacts[index];
    return ListTile(
      title: Text(cUser.name ?? "name"),
      subtitle: Text(cUser.phone ?? "Phone"),
      leading: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: FadeInImage(
          fadeInDuration: Duration(seconds: 1),
          placeholder: AssetImage("assets/images/avatar.png"),
          image: cUser.hasImage()
              ? NetworkImage(cUser.imageUrl)
              : AssetImage("assets/images/avatar.png"),
          fit: BoxFit.cover,
        ),
      ),
      onTap: () => _startShat(index),
    );
  }

  void _startShat(int index) async {
    final User cUser =
        await User.getUserData((await FirebaseAuth.instance.currentUser()).uid);
    final database = FirebaseDatabase.instance.reference();
    String chatkey = database.push().key;
    await database.child("chats/$chatkey").update({
      "users": [cUser.id, contacts[index].id],
    });
    await database
        .child("users/${cUser.id}/chats/$chatkey/name")
        .set("${contacts[index].name ?? contacts[index].phone}");
    await database
        .child("users/${contacts[index].id}/chats/$chatkey/name")
        .set("${cUser.name ?? cUser.phone}");
    Navigator.pop(context);
  }
}
