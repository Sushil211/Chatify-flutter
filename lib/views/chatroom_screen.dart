import 'package:chaticon/helper/authenticate.dart';
import 'package:chaticon/helper/constants.dart';
import 'package:chaticon/helper/helperfunctions.dart';
import 'package:chaticon/services/auth.dart';
import 'package:chaticon/services/database.dart';
import 'package:chaticon/views/conversation_screen.dart';
import 'package:chaticon/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return ChatRoomsTile(
              username: snapshot.data.docs[index]
                  .data()["chatroomId"]
                  .toString()
                  .replaceAll('_', '')
                  .replaceAll(Constants.myName, ''),
              chatroomId: snapshot.data.docs[index].data()["chatroomId"],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatify',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              print('signout');
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              HelperFunctions.saveUserNameSharedPreference('');
              HelperFunctions.saveUserEmailSharedPreference('');
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String username;
  final String chatroomId;
  ChatRoomsTile({this.username, this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatroomId),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        color: Color(0xff11698e),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text(
                '${this.username.substring(0, 1).toUpperCase()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
