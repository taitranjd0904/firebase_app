import 'package:firebase_app/helper/functions.dart';
import 'package:firebase_app/views/search_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String myName = "";
  @override
  void initState() {
    getUserInfor();
    super.initState();
  }

  getUserInfor() async {
    myName = (await HelperFunctions.getUserNameSharedPreference())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Text('ChatScreen'),
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
