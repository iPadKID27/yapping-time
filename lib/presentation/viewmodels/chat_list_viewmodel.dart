import '../../core/base/base_view_model.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel extends BaseViewModel {
  final ChatService _chatService;
  final AuthService _authService;
  
  String _selectedCategory = 'All';

  ChatListViewModel({
    required ChatService chatService,
    required AuthService authService,
  })  : _chatService = chatService,
        _authService = authService;

  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Stream<QuerySnapshot> get userChatsStream {
    final user = _authService.getCurrentUser();
    if (user != null) {
      return _chatService.getUserChats(user.uid);
    }
    return const Stream.empty();
  }

  Stream<List<Map<String, dynamic>>> get usersStream {
    return _chatService.getUserStream();
  }

  Future<void> pinChat(String chatRoomID) async {
    try {
      setLoading();
      await _chatService.pinChat(chatRoomID);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
Future<void> deleteChat(String chatRoomID) async {
  try {
    final currentUserID = _authService.getCurrentUser()?.uid;
    if (currentUserID == null) return;

    // Delete from chats collection
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .delete();

    // Delete all messages in the chat
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete from pinned chats if it exists
    final pinnedQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserID)
        .collection('pinnedChats')
        .where('chatRoomID', isEqualTo: chatRoomID)
        .get();

    for (var doc in pinnedQuery.docs) {
      await doc.reference.delete();
    }

    print('Chat deleted successfully: $chatRoomID');
  } catch (e) {
    print('Error deleting chat: $e');
  }
}
  Future<void> updateChatCategory(String chatRoomID, String category) async {
    try {
      setLoading();
      await _chatService.updateChatCategory(chatRoomID, category);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}