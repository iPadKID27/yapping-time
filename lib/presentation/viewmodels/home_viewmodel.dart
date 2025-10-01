import '../../core/base/base_view_model.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends BaseViewModel {
  final ChatService _chatService;
  final AuthService _authService;

  HomeViewModel({
    required ChatService chatService,
    required AuthService authService,
  })  : _chatService = chatService,
        _authService = authService;

  Stream<QuerySnapshot> get pinnedChatsStream {
    final user = _authService.getCurrentUser();
    if (user != null) {
      return _chatService.getPinnedChats(user.uid);
    }
    return const Stream.empty();
  }

  Future<void> unpinChat(String chatRoomID) async {
    try {
      setLoading();
      await _chatService.unpinChat(chatRoomID);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}