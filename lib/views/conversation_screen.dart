import 'package:firebase_app/services/database.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  const Conversation({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  sendMessage() {
    // databaseMethods.sendMessage(widget.chatRoomId, chatMessageData)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              child: TextField(
                // controller: _searchController,
                textInputAction: TextInputAction.search,
                // onSubmitted: (value) {
                //   initiateSearch();
                // },
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
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
