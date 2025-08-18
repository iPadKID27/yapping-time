import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yappingtime/auth/authService.dart';
import 'package:yappingtime/components/myTextfield.dart';
import 'package:yappingtime/services/chat/chatService.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(receiverID, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          buildUserInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    String senderID = authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading..");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrenUser = data['senderID'] == authService.getCurrentUser()!.uid;
    var alignment = isCurrenUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrenUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data["message"]),
        ],
      )
      );
  }

  Widget buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: MyTestField(
            controller: messageController,
            hintText: "Type a message",
            obscureText: false,
          ),
        ),
        IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward)),
      ],
    );
  }
}
