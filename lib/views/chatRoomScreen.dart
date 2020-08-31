import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/constance.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/helper.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin-up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomstream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomstream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.documents[index].data["chatroomid"]
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constance.email, ""),
                        snapshot.data.documents[index].data["chatroomid"]);
                  })
              : Container();
        });
  }

  _signout() {
    setState(() async {
      await firebaseAuth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UiDesign()));
    });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constance.email = await HelperFunctions.getuserUserEmail();
    databaseMethods.getChatRooms(Constance.email).then((value) {
      setState(() {
        chatRoomstream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              _signout();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String email;
  final String chatroomid;
  ChatRoomTile(this.email, this.chatroomid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Conversation(chatroomid)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text('${email.substring(0, 1).toUpperCase()}'),
            ),
            SizedBox(
              width: 8,
            ),
            Text(email)
          ],
        ),
      ),
    );
  }
}
