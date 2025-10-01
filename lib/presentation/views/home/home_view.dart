import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/chat_service.dart';
import '../../../services/auth_service.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'widgets/pinned_chat_widget.dart';
import '../chat/chat_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        chatService: context.read<ChatService>(),
        authService: context.read<AuthService>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pinned Chats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: viewModel.pinnedChatsStream,
                    builder: (context, pinnedSnapshot) {
                      if (pinnedSnapshot.hasError) {
                        return const Center(child: Text("Error loading pinned chats"));
                      }

                      if (pinnedSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!pinnedSnapshot.hasData || pinnedSnapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No pinned chats yet'),
                        );
                      }

                      return ListView.builder(
                        itemCount: pinnedSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final pinnedDoc = pinnedSnapshot.data!.docs[index];
                          final chatRoomID = pinnedDoc['chatRoomID'];

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('chats')
                                .doc(chatRoomID)
                                .get(),
                            builder: (context, chatSnapshot) {
                              if (!chatSnapshot.hasData) {
                                return const SizedBox.shrink();
                              }

                              final chatData = chatSnapshot.data!.data() as Map<String, dynamic>?;
                              if (chatData == null) return const SizedBox.shrink();

                              final participants = List<String>.from(chatData['participants'] ?? []);
                              final currentUserID = context.read<AuthService>().getCurrentUser()?.uid;
                              final otherUserID = participants.firstWhere(
                                (id) => id != currentUserID,
                                orElse: () => '',
                              );

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(otherUserID)
                                    .get(),
                                builder: (context, userSnapshot) {
                                  if (!userSnapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }

                                  final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                  final email = userData?['email'] ?? 'Unknown';

                                  return PinnedChatWidget(
                                    email: email,
                                    lastMessage: chatData['lastMessage'] ?? '',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatDetailView(
                                            receiverEmail: email,
                                            receiverID: otherUserID,
                                          ),
                                        ),
                                      );
                                    },
                                    onUnpin: () {
                                      viewModel.unpinChat(chatRoomID);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}