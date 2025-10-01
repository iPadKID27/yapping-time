import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;
  final AuthService authService;

  ChatBloc({required this.chatService, required this.authService}) : super(ChatInitial()) {
    on<ChatLoadRequested>(_onChatLoadRequested);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatPinToggled>(_onPinToggled);
    on<ChatCategoryChanged>(_onCategoryChanged);
  }

  void _onChatLoadRequested(ChatLoadRequested event, Emitter<ChatState> emit) {
    emit(ChatLoaded());
  }

  Future<void> _onSendMessage(ChatSendMessage event, Emitter<ChatState> emit) async {
    try {
      await chatService.sendMessage(event.receiverID, event.message);
      emit(ChatMessageSent());
      emit(ChatLoaded());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onPinToggled(ChatPinToggled event, Emitter<ChatState> emit) async {
    try {
      if (event.isPinned) {
        await chatService.unpinChat(event.chatRoomID);
      } else {
        await chatService.pinChat(event.chatRoomID);
      }
      emit(ChatLoaded());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onCategoryChanged(ChatCategoryChanged event, Emitter<ChatState> emit) async {
    try {
      await chatService.updateChatCategory(event.chatRoomID, event.category);
      emit(ChatLoaded());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}