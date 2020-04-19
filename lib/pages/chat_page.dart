import 'package:clone_whats_app/firebase/database.dart';
import 'package:clone_whats_app/utils/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  String _myId;
  String _cChatId;
  double _maxWidth;
  @override
  Widget build(BuildContext context) {
    _maxWidth = MediaQuery.of(context).size.width * .7;

    _cChatId = ModalRoute.of(context).settings.arguments;
    if (_cChatId == null) {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("chat Name"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: getChatMessages(chatId: _cChatId),
              builder: (ctx, AsyncSnapshot<List<Message>> stream) {
                if (stream.hasError || stream.data == null) {
                  return Center(
                    child: Text("No Messages yet"),
                  );
                }
                return ListView(
                  children: stream.data.map((Message val) {
                    return _buildMessageItem(val);
                  }).toList(),
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message val) {
    bool isMe = val.senderId == _myId;
    return Align(
      alignment: Alignment(isMe ? -1 : 1, 0),
      child: Container(
        margin: EdgeInsets.all(5),
        constraints: BoxConstraints(maxWidth: _maxWidth),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.only(
            bottomLeft: isMe ? Radius.circular(0) : Radius.circular(5),
            bottomRight: isMe ? Radius.circular(5) : Radius.circular(0),
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(val.data),
      ),
    );
  }

  TextEditingController _controller = TextEditingController();
  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onSubmitted: (val) {
          _sendMessage();
        },
        decoration: InputDecoration(
          labelText: "Message",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    await sendMessage(message: _controller.text, chatId: _cChatId);
    _controller.text = " ";
  }
}
