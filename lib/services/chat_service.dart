import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';
import '../core/constants/app_constants.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection(AppConstants.usersCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();



    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatRoomID)
        .collection(AppConstants.messagesCollection)
        .add(newMessage.toMap());

    await _firestore.collection(AppConstants.chatsCollection).doc(chatRoomID).update({
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });
    
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatRoomID)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats(String userID) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .where('participants', arrayContains: userID)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<void> pinChat(String chatRoomID) async {
    final String currentUserID = _auth.currentUser!.uid;
    
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(currentUserID)
        .collection(AppConstants.pinnedChatsCollection)
        .doc(chatRoomID)
        .set({
      'chatRoomID': chatRoomID,
      'pinnedAt': Timestamp.now(),
    });
  }

  Future<void> unpinChat(String chatRoomID) async {
    final String currentUserID = _auth.currentUser!.uid;
    
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(currentUserID)
        .collection(AppConstants.pinnedChatsCollection)
        .doc(chatRoomID)
        .delete();
  }

  Stream<QuerySnapshot> getPinnedChats(String userID) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userID)
        .collection(AppConstants.pinnedChatsCollection)
        .orderBy('pinnedAt', descending: true)
        .snapshots();
  }

  Future<void> updateChatCategory(String chatRoomID, String category) async {
    await _firestore.collection(AppConstants.chatsCollection).doc(chatRoomID).update({
      'chatType': category.toLowerCase(),
    });
  }
}