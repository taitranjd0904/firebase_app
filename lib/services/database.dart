import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError(
          (e) => print(
            e.toString(),
          ),
        );
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  searchByName(String name) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: name)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> sendMessage(String chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomID) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("createAt", descending: false)
        .snapshots();
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
