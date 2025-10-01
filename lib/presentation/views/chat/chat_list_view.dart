import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/chat_service.dart';
import '../../../services/auth_service.dart';
import '../../viewmodels/chat_list_viewmodel.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/chat_tile_widget.dart';
import 'widgets/chat_category_tabs.dart';
import 'chat_detail_view.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  // Mock user data for testing
  static final List<Map<String, dynamic>> mockUsers = [
    {
      'uid': 'mock_user_1',
      'email': 'john.doe@example.com',
      'displayName': 'John Doe',
      'chatType': AppConstants.chatTypePersonal,
    },
    {
      'uid': 'mock_user_2',
      'email': 'jane.smith@example.com',
      'displayName': 'Jane Smith',
      'chatType': AppConstants.chatTypeWork,
    },
    {
      'uid': 'mock_user_3',
      'email': 'bob.wilson@example.com',
      'displayName': 'Bob Wilson',
      'chatType': AppConstants.chatTypeGroup,
    },
    {
      'uid': 'mock_user_4',
      'email': 'alice.johnson@example.com',
      'displayName': 'Alice Johnson',
      'chatType': AppConstants.chatTypePersonal,
    },
    {
      'uid': 'mock_user_5',
      'email': 'charlie.brown@example.com',
      'displayName': 'Charlie Brown',
      'chatType': AppConstants.chatTypeWork,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatListViewModel(
        chatService: context.read<ChatService>(),
        authService: context.read<AuthService>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Consumer<ChatListViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                ChatCategoryTabs(
                  selectedCategory: viewModel.selectedCategory,
                  onCategorySelected: viewModel.setCategory,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: viewModel.userChatsStream,
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.hasError) {
                        print('Chat stream error: ${chatSnapshot.error}');
                        return _buildMockUsersList(context, viewModel);
                      }

                      if (chatSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final chats = chatSnapshot.data?.docs ?? [];
                      final filteredChats = chats.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final chatType = data['chatType'] ?? 'personal';

                        if (viewModel.selectedCategory == AppConstants.categoryAll) {
                          return true;
                        } else if (viewModel.selectedCategory == AppConstants.categoryPersonal) {
                          return chatType == AppConstants.chatTypePersonal;
                        } else if (viewModel.selectedCategory == AppConstants.categoryWork) {
                          return chatType == AppConstants.chatTypeWork;
                        } else if (viewModel.selectedCategory == AppConstants.categoryGroups) {
                          return chatType == AppConstants.chatTypeGroup;
                        }
                        return true;
                      }).toList();

                      if (filteredChats.isEmpty) {
                        return _buildMockUsersList(context, viewModel);
                      }

                      return ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          final chatDoc = filteredChats[index];
                          final chatData = chatDoc.data() as Map<String, dynamic>;
                          final chatRoomID = chatDoc.id;
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

                              return Dismissible(
                                key: Key(chatRoomID),
                                confirmDismiss: (direction) async {
                                  if (direction == DismissDirection.endToStart) {
                                    // Swipe left to delete
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Chat'),
                                          content: const Text('Are you sure you want to delete this chat?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (direction == DismissDirection.startToEnd) {
                                    // Swipe right to pin
                                    viewModel.pinChat(chatRoomID);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Chat pinned!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    return false;
                                  }
                                  return false;
                                },
                                onDismissed: (direction) {
                                  if (direction == DismissDirection.endToStart) {
                                    viewModel.deleteChat(chatRoomID);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Chat deleted'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                background: Container(
                                  color: Colors.green,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(Icons.push_pin, color: Colors.white, size: 30),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                                ),
                                child: ChatTileWidget(
                                  email: email,
                                  lastMessage: chatData['lastMessage'] ?? '',
                                  chatType: chatData['chatType'] ?? 'personal',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailView(
                                          receiverEmail: email,
                                          receiverID: otherUserID,
                                          receiverDisplayName: userData?['displayName'],
                                        ),
                                      ),
                                    );
                                  },
                                  onPin: () {
                                    viewModel.pinChat(chatRoomID);
                                  },
                                  onCategoryChange: (category) {
                                    viewModel.updateChatCategory(chatRoomID, category);
                                  },
                                ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNewChatDialog(context),
          child: const Icon(Icons.add),
          tooltip: 'Start New Chat',
        ),
      ),
    );
  }

  Future<void> _showNewChatDialog(BuildContext context) async {
    String inputEmail = '';
    String selectedCategory = AppConstants.chatTypePersonal;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Start New Chat'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => inputEmail = value,
                    decoration: const InputDecoration(
                      hintText: 'Enter user email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Category:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'personal',
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 20),
                            SizedBox(width: 8),
                            Text('Personal'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'work',
                        child: Row(
                          children: [
                            Icon(Icons.work, size: 20),
                            SizedBox(width: 8),
                            Text('Work'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'group',
                        child: Row(
                          children: [
                            Icon(Icons.group, size: 20),
                            SizedBox(width: 8),
                            Text('Group'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, {
                    'email': inputEmail,
                    'category': selectedCategory,
                  }),
                  child: const Text('Start Chat'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null &&
        result['email'] != null &&
        result['email']!.isNotEmpty &&
        context.mounted) {
      await _startChatWithEmail(
        context,
        result['email']!,
        result['category']!,
      );
    }
  }

  Future<void> _startChatWithEmail(
    BuildContext context,
    String email,
    String chatCategory,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.trim().toLowerCase())
          .limit(1)
          .get();

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        final userID = userQuery.docs.first.id;

        final currentUserID = context.read<AuthService>().getCurrentUser()?.uid;
        if (userID == currentUserID) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You cannot chat with yourself!')),
            );
          }
          return;
        }

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailView(
                receiverEmail: userData['email'] ?? email,
                receiverID: userID,
                receiverDisplayName: userData['displayName'],
                chatCategory: chatCategory,
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not found. Please check the email address.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMockUsersList(BuildContext context, ChatListViewModel viewModel) {
    final filteredMockUsers = mockUsers.where((user) {
      final chatType = user['chatType'] ?? AppConstants.chatTypePersonal;

      if (viewModel.selectedCategory == AppConstants.categoryAll) {
        return true;
      } else if (viewModel.selectedCategory == AppConstants.categoryPersonal) {
        return chatType == AppConstants.chatTypePersonal;
      } else if (viewModel.selectedCategory == AppConstants.categoryWork) {
        return chatType == AppConstants.chatTypeWork;
      } else if (viewModel.selectedCategory == AppConstants.categoryGroups) {
        return chatType == AppConstants.chatTypeGroup;
      }
      return true;
    }).toList();

    if (filteredMockUsers.isEmpty) {
      return const Center(child: Text('No mock users available'));
    }

    return ListView.builder(
      itemCount: filteredMockUsers.length,
      itemBuilder: (context, index) {
        final userData = filteredMockUsers[index];
        return ChatTileWidget(
          email: userData['email'] ?? 'Unknown',
          lastMessage: 'Start a conversation',
          chatType: userData['chatType'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailView(
                  receiverEmail: userData['email'],
                  receiverID: userData['uid'],
                  receiverDisplayName: userData['displayName'],
                ),
              ),
            );
          },
          onPin: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${userData['email']} pinned (mock)')),
            );
          },
          onCategoryChange: (category) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Category changed to $category (mock)')),
            );
          },
        );
      },
    );
  }
}