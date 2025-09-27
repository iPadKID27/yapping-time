import 'package:flutter/material.dart';
import 'package:yappingtime/auth/auth_service.dart';
import 'package:yappingtime/components/my_drawer.dart';
import 'package:yappingtime/components/user_tile.dart';
import 'package:yappingtime/pages/chat_page.dart';
import 'package:yappingtime/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: buildUserList(),
    );
  }

  Widget buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
   if (userData['uid'] != authService.getCurrentUser()?.uid) {
     return UserTile(
      text: userData['email'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData['email'],
              receiverID: userData["uid"],
              ),
          ),
        );
      },
    );
   } else {
     return Container(); // Skip the current user
   }
  }
}
