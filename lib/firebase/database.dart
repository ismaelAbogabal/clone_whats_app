import 'package:clone_whats_app/firebase/aut_utils.dart';
import 'package:clone_whats_app/utils/chat.dart';
import 'package:clone_whats_app/utils/message.dart';
import 'package:firebase_database/firebase_database.dart';

Stream<List<SimpleChat>> getChats() {
  return FirebaseDatabase.instance
      .reference()
      .child("users/${cUser.id}/chats/")
      .orderByPriority()
      .onValue
      .map(
    (Event a) {
      print("chat data === ${a.snapshot.value}");
      Map data = a.snapshot.value;
      List<SimpleChat> chats = [];
      data.forEach((key, val) {
        chats.add(
          SimpleChat(
            id: key,
            name: val["name"],
            lastMessage: val["lastMessage"] ?? "Start the Conversation",
          ),
        );
      });
      return chats;
    },
  );
}

Future sendMessage({String message, chatId}) async {
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  await ref.child("chats/$chatId/users").once().then((val) {
    (val.value as List).forEach((id) {
      _changeLastMessage(id, chatId, message);
    });
  });
  String k = ref.push().key;
  await ref.child("chats/$chatId/messages/$k").set({
    "data": message,
    "senderid": cUser.id,
  });
}

Future _changeLastMessage(String userId, chatId, String message) {
  return FirebaseDatabase.instance
      .reference()
      .child("users/$userId/chats/$chatId/lastMessage")
      .set(message);
}

Stream<List<Message>> getChatMessages({String chatId}) {
  return FirebaseDatabase.instance
      .reference()
      .child("chats/$chatId/messages")
      .orderByPriority()
      .onValue
      .map(
    (val) {
      if (val.snapshot.value == null)
        throw Stream.error("no data in the data bsae");
      Map data = val.snapshot.value;
      return data.entries.map(
        (mapEntry) {
          print(mapEntry);
          return Message(
            id: mapEntry.key,
            senderId: mapEntry.value["senderId"],
            data: mapEntry.value["data"],
          );
        },
      ).toList();
    },
  );
}
