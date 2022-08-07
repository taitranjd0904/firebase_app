import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helper/functions.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/views/conversation_screen.dart';
import 'package:firebase_app/views/search_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String myName = "";
  Stream<QuerySnapshot>? chatRooms;
  @override
  void initState() {
    getUserInfor();
    super.initState();
  }

  getUserInfor() async {
    myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(myName).then((snapshot) => {
          setState(() {
            chatRooms = snapshot;
            print(
                "we got the data + ${chatRooms.toString()} this is name  $myName");
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: chatRooms,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ChatRoomsTile(
                        userName: (snapshot.data!.docs[index].data()
                                as Map)["chatRoomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(myName, ""),
                        chatRoomId: (snapshot.data!.docs[index].data()
                            as Map)["chatRoomId"],
                        myName: myName,
                      );
                    },
                  )
                : Container(
                    child: Text('hii'),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(myName: myName),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String myName;

  const ChatRoomsTile(
      {Key? key,
      required this.userName,
      required this.chatRoomId,
      required this.myName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Conversation(
              chatRoomId: chatRoomId,
              myName: myName,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    // fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
