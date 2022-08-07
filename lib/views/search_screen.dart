import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/views/conversation_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String myName;
  const SearchScreen({Key? key, required this.myName}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? searchSnapshot;
  bool haveUserSearched = false;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  initiateSearch() async {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(_searchController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        print("$searchSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  // createChatRoom(String userName) {
  //   String chatRoomID = getChatRoomID(userName, widget.myName);
  //   List<String> users = [userName, widget.myName];
  //   Map<String, dynamic> chatRoomMap = {
  //     "users": users,
  //     "chatRoomId": chatRoomID
  //   };
  //   databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchScreen'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      initiateSearch();
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.5),
                      ),
                      labelText: 'Search',
                      suffixIcon: const Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: haveUserSearched
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              Map data =
                                  searchSnapshot?.docs[index].data() as Map;
                              return SearchItem(
                                name: data["name"],
                                email: data["email"],
                                myName: widget.myName,
                              );
                            },
                            itemCount: searchSnapshot?.docs.length,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
    );
  }
}

class SearchItem extends StatelessWidget {
  final String name;
  final String email;
  final String myName;

  const SearchItem(
      {Key? key, required this.name, required this.email, required this.myName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    createChatRoom(String userName) {
      print(userName);
      print(myName);
      if (userName != myName) {
        String chatRoomID = getChatRoomID(userName, myName);
        List<String> users = [userName, myName];
        Map<String, dynamic> chatRoomMap = {
          "users": users,
          "chatRoomId": chatRoomID
        };
        DatabaseMethods().createChatRoom(chatRoomID, chatRoomMap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Conversation(chatRoomId: chatRoomID, myName: myName),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            createChatRoom(name);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // color: Colors.blue,
            child: const Icon(Icons.chat),
          ),
        )
      ],
    );
  }
}

getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b-$a";
  } else {
    return "$a-$b";
  }
}
