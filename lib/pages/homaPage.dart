import 'package:flutter/material.dart';
import 'package:yappingtime/auth/authService.dart';
import 'package:yappingtime/components/myDrawer.dart';
import 'package:yappingtime/components/userTile.dart';
import 'package:yappingtime/pages/chatPage.dart';
import 'package:yappingtime/services/chat/chatService.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
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
   if (userData['email'] != authService.getCurrentUser()) {
     return UserTile(
      text: userData['email'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(receiverEmail: userData['email']),
          ),
        );
      },
    );
   } else {
     return Container(); // Skip the current user
   }
  }
}
