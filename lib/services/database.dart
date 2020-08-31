import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getuser(String email) async {
    return await Firestore.instance
        .collection("user")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("user").add(userMap);
  }

  creatChatroom(String chatroomid, chatroommap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomid)
        .setData(chatroommap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatroomid, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomid)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomid) async {
    return await Firestore.instance
        .collection('chatroom')
        .document(chatroomid)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String email) async {
    return await Firestore.instance
        .collection('chatroom')
        .where('user', arrayContains: email)
        .snapshots();
  }
}
