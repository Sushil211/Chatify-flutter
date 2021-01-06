import 'package:chaticon/helper/constants.dart';
import 'package:chaticon/services/database.dart';
import 'package:chaticon/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  ConversationScreen(this.chatroomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream messagesStream;

  Widget messageList() {
    return StreamBuilder(
      stream: messagesStream,
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
            return MessageTile(
              snapshot.data.docs[index].data()['message'],
              snapshot.data.docs[index].data()['sender'] == Constants.myName,
            );
          },
        );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sender": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      databaseMethods.addMessages(widget.chatroomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getMessages(widget.chatroomId).then((val) {
      setState(() {
        messagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        color: Color(0xFF00303f),
        child: Stack(
          children: [
            messageList(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xff0a043c),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Transform.rotate(
                        angle: 325 * math.pi / 180,
                        child: Icon(
                          Icons.send,
                          color: Colors.white54,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool amITheSender;
  MessageTile(this.message, this.amITheSender);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: amITheSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: amITheSender
                  ? [const Color(0xffc0e218), const Color(0xff54e346)]
                  : [const Color(0xffbedbbb), const Color(0xff8db596)],
            ),
            borderRadius: amITheSender
                ? BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    //topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0),
                  )
                : BorderRadius.only(
                    //topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0),
                  )),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
