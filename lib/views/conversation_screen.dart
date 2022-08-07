import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/controller/notification.dart';
import 'package:firebase_app/services/database.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String myName;
  const Conversation({Key? key, required this.chatRoomId, required this.myName})
      : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  final TextEditingController _messageController = TextEditingController();
  Stream<QuerySnapshot>? chatMessageStream;
  late QuerySnapshot chatList;
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messageController.text,
        "sendBy": widget.myName,
        "createAt": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.sendMessage(widget.chatRoomId, messageMap);
      _messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getChats(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  Future<void> sendNotification() {
    //   return await _fcmNotificationService.sendNotificationToUser(
    //     tokenList: ,
    //           title: 'Welcome',
    //           body: "Bao dep chai que Dong Thap",
    //         ),
    // }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatMessageStream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                              message: (snapshot.data?.docs[index].data()!
                                  as Map)["message"],
                              sendByMe: widget.myName ==
                                  (snapshot.data?.docs[index].data()!
                                      as Map)["sendBy"]);
                        },
                      )
                    : Container(
                        color: Colors.blue,
                        child: Text('khong data'),
                      );
              },
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.white,
                // height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _messageController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    labelText: 'Message...',
                    suffixIcon: GestureDetector(
                      onTap: sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({Key? key, required this.message, required this.sendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [Colors.blue, Colors.red]
                  : [Colors.yellow, Colors.red],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                // fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
