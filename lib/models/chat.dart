import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatRoomID;
  final List<String> participants;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final String chatType;
  final bool isPinned;

  Chat({
    required this.chatRoomID,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.chatType,
    this.isPinned = false,
  });

  factory Chat.fromMap(Map<String, dynamic> map, String chatRoomID) {
    return Chat(
      chatRoomID: chatRoomID,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? Timestamp.now(),
      chatType: map['chatType'] ?? 'personal',
      isPinned: map['isPinned'] ?? false,
    );
  }
}