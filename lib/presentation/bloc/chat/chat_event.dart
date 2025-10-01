abstract class ChatEvent {}

class ChatLoadRequested extends ChatEvent {}

class ChatSendMessage extends ChatEvent {
  final String receiverID;
  final String message;

  ChatSendMessage({required this.receiverID, required this.message});
}

class ChatPinToggled extends ChatEvent {
  final String chatRoomID;
  final bool isPinned;

  ChatPinToggled({required this.chatRoomID, required this.isPinned});
}

class ChatCategoryChanged extends ChatEvent {
  final String chatRoomID;
  final String category;

  ChatCategoryChanged({required this.chatRoomID, required this.category});
}