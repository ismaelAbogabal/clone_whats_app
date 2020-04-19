import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clone_whats_app/utils/image.dart';
import 'package:clone_whats_app/utils/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static User cUser = User();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initIt();
  }

  void initIt() async {
    String id = (await FirebaseAuth.instance.currentUser()).uid;
    cUser = await User.getUserData(id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 30),
              _buildImage(color),
              SizedBox(height: 10),
              _buildName(color),
              _buildDivider(),
              _buildBio(color),
              _buildDivider(),
              _buildPhone(color),
              _buildDivider(),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.green.withOpacity(.2),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.grey,
      indent: 20,
      endIndent: 20,
    );
  }

  Center _buildImage(Color color) {
    print(cUser.imageUrl);
    return Center(
      child: Stack(
        alignment: Alignment(.9, .8),
        children: <Widget>[
          CircleAvatar(
            radius: 100,
            backgroundImage: cUser == null || cUser.imageUrl != null
                ? NetworkImage(cUser.imageUrl)
                : AssetImage("assets/images/avatar.png"),
          ),
          IconButton(
            icon: CircleAvatar(
                child: Icon(Icons.camera_alt, color: Colors.white),
                backgroundColor: color),
            onPressed: _editImage,
          ),
        ],
      ),
    );
  }

  Widget _buildName(Color color) {
    return ListTile(
      title: Text("Name"),
      subtitle: Text(cUser.name ?? "no name yet"),
      leading: Icon(Icons.person, color: color),
      onTap: _editName,
      trailing: Icon(Icons.edit),
    );
  }

  final TextEditingController _nameController = TextEditingController(
    text: cUser.name,
  );
  void _editName() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Name"),
            contentPadding: EdgeInsets.all(10),
            content: TextField(
              controller: _nameController,
              autofocus: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  print(cUser.toMap());
                  cUser.name = _nameController.text.trim();
                  cUser.updateUserData().then((val) {
                    setState(() {});
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget _buildBio(Color color) {
    return ListTile(
      title: Text("About"),
      subtitle: Text(cUser.bio ?? "available"),
      leading: Icon(Icons.info, color: color),
      trailing: Icon(Icons.edit),
      onTap: _editBio,
    );
  }

  TextEditingController _bioController = TextEditingController(text: cUser.bio);
  void _editBio() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Bio"),
          contentPadding: EdgeInsets.all(10),
          content: TextField(
            controller: _bioController,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Update"),
              onPressed: () {
                cUser.bio = _bioController.text.trim();
                cUser.updateUserData().then((val) {
                  setState(() {});
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhone(Color color) {
    return ListTile(
      title: Text("Phone"),
      subtitle: Text(cUser.phone ?? ""),
      leading: Icon(Icons.phone, color: color),
    );
  }

  void _editImage() {
    setState(() {
      isLoading = true;
    });
    getImage(context).then((val) {
      if (val != null)
        FirebaseStorage.instance
            .ref()
            .child("images/${cUser.id}")
            .putFile(val)
            .onComplete
            .then((val) async {
          cUser.imageUrl = await val.ref.getDownloadURL();

          await cUser.updateUserData();
          setState(() {
            isLoading = false;
          });
        });
    });
  }
}
