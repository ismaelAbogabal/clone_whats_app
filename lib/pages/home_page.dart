import 'package:clone_whats_app/firebase/aut_utils.dart';
import 'package:clone_whats_app/firebase/database.dart';
import 'package:clone_whats_app/utils/chat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:clone_whats_app/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            expandedHeight: 0,
            snap: false,
            title: Text("WhatsApp"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  logOUt().then((va) {
                    Navigator.pushReplacementNamed(context, "/auth");
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.portrait),
                onPressed: () => Navigator.pushNamed(context, "/profile"),
              ),
            ],
          ),
          StreamBuilder<List<SimpleChat>>(
              stream: getChats(),
              builder: (context, snapshot) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data == null
                        ? [Container()]
                        : snapshot.data.map(_buildChatItem).toList(),
                  ),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/contacts");
        },
        child: Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatItem(SimpleChat e) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(.3),
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.person_pin),
        title: Text(e.name),
        subtitle: Text(e.lastMessage ?? "no messages yet"),
        onLongPress: () {
          utils.alert(
            context: context,
            title: "Are you shur",
            content: Text("Deleting this chat"),
            onOk: () => _deleteChat(e),
          );
        },
        onTap: () {
          Navigator.pushNamed(context, "/chat", arguments: e.id);
        },
      ),
    );
  }

  _deleteChat(SimpleChat chat) async {
    final reference = FirebaseDatabase.instance.reference();

    List users = await chat.users();
    users.forEach((val) async {
      await reference.child("users/$val/chats/${chat.id}").remove();
    });
    await reference.child("chats/${chat.id}").remove();
  }
}
