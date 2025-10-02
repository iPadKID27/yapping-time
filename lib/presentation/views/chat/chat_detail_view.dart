import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../services/chat_service.dart';
import '../../../services/auth_service.dart';
import 'widgets/message_bubble_widget.dart';
import 'widgets/message_input_widget.dart';

class ChatDetailView extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final String? receiverDisplayName;
  final String? chatCategory;

  const ChatDetailView({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    this.receiverDisplayName,
    this.chatCategory,
  });

  // Mock messages for testing
  static final List<Map<String, dynamic>> mockMessages = [
    {
      'message': 'Hey! How are you?',
      'senderID': 'mock_user_1',
      'timestamp': Timestamp.now(),
    },
    {
      'message': 'I\'m doing great, thanks for asking!',
      'senderID': 'current_user',
      'timestamp': Timestamp.now(),
    },
    {
      'message': 'Would you like to grab coffee sometime?',
      'senderID': 'mock_user_1',
      'timestamp': Timestamp.now(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final chatService = context.read<ChatService>();
    final authService = context.read<AuthService>();
    final currentUserID = authService.getCurrentUser()!.uid;

    final displayTitle = receiverDisplayName ?? receiverEmail;

    // Create chat room with category when first message is sent
    _ensureChatRoomExists(currentUserID, chatService);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayTitle,
              style: const TextStyle(fontSize: 16),
            ),
            if (receiverDisplayName != null)
              Text(
                receiverEmail,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessages(currentUserID, receiverID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Message stream error: ${snapshot.error}');
                  return _buildMockMessagesList(currentUserID);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                if (messages.isEmpty) {
                  if (receiverID.startsWith('mock_user_')) {
                    return _buildMockMessagesList(currentUserID);
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation with $displayTitle!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = messageData['senderID'] == currentUserID;
                    final timestamp = messageData['timestamp'] as Timestamp?;

                    return MessageBubbleWidget(
                      message: messageData['message'] ?? '',
                      isCurrentUser: isCurrentUser,
                      timestamp: timestamp,
                    );
                  },
                );
              },
            ),
          ),
          MessageInputWidget(
            onSend: (message) async {
              if (message.trim().isNotEmpty) {
                if (receiverID.startsWith('mock_user_')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cannot send messages to mock users. Real chat coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Ensure chat room exists before sending message
                  await _ensureChatRoomExists(currentUserID, chatService);
                  chatService.sendMessage(receiverID, message);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _ensureChatRoomExists(String currentUserID, ChatService chatService) async {
    try {
      // Get chat room ID
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Check if chat room exists
      final chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomID)
          .get();

      // Create chat room if it doesn't exist
      if (!chatDoc.exists) {
        await FirebaseFirestore.instance.collection('chats').doc(chatRoomID).set({
          'participants': [currentUserID, receiverID],
          'chatType': chatCategory ?? 'personal',
          'lastMessage': '',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else if (chatCategory != null) {
        // Update chat type (category)
        await FirebaseFirestore.instance.collection('chats').doc(chatRoomID).update({
          'chatType': chatCategory,
        });
      }
    } catch (e) {
      print('Error ensuring chat room exists: $e');
    }
  }

  Widget _buildMockMessagesList(String currentUserID) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockMessages.length,
      itemBuilder: (context, index) {
        final messageData = mockMessages[index];
        final isCurrentUser = messageData['senderID'] == 'current_user';
        final timestamp = messageData['timestamp'] as Timestamp?;

        return MessageBubbleWidget(
          message: messageData['message'] ?? '',
          isCurrentUser: isCurrentUser,
          timestamp: timestamp,
        );
      },
    );
  }
}