import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/constance.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot searchSnapshot;

  //Search User
  initiateSearch() {
    databaseMethods.getuser(searchTextEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }
  //CREATE CHATROOM,SEND USER TO THE CONVERSATION SCREEN

  createChatroomAndStartConversation(String email) {
    if (email != Constance.email) {
      String chatRoomId = getChatRoomId(email, Constance.email);
      List<String> users = [email, Constance.email];
      Map<String, dynamic> chatroomMap = {
        "user": users,
        "chatroomid": chatRoomId
      };
      databaseMethods.creatChatroom(chatRoomId, chatroomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
    } else {
      print('You can not send Message Yourself ');
    }
  }

  //ListView

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                email: searchSnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    // initiateSearch();
    super.initState();
  }

  Widget SearchTile({String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            children: [
              Text(email, style: TextStyle(color: Colors.black, fontSize: 18)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(email);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Text('Message'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by Emailid....',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        'assets/search-icons.png',
                        scale: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
