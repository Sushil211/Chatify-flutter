import 'package:chaticon/helper/constants.dart';
import 'package:chaticon/services/database.dart';
import 'package:chaticon/views/conversation_screen.dart';
import 'package:chaticon/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  // ignore: non_constant_identifier_names
  Widget SearchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot.docs[index].data()['name'],
                email: searchSnapshot.docs[index].data()['email'],
              );
            },
          )
        : Container();
  }

  startSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  //Send user to the conversation room
  createChatRoomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatroomId = getChatroomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatroomId
      };

      DatabaseMethods().createChatRoom(chatroomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomId)));
    } else {
      print("Invalid chatRoom");
    }
  }

  Widget SearchTile({String username, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      color: Color(0xfff6f6f6),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Text(
                "Message",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xffc87941),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        color: Color(0xffbedbbb),
        child: Column(
          children: [
            Container(
              color: Color(0xff0a043c),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      startSearch();
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white54,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SearchList(),
          ],
        ),
      ),
    );
  }
}

getChatroomId(String a, String b) {
  if (a.compareTo(b) <= 0) {
    return "$a\_$b";
  } else {
    return "$b\_$a";
  }
}
