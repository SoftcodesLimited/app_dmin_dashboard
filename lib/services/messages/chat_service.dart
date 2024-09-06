import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/messaging/message_model.dart';
import 'package:myapp/services/database/database.dart';

class ChatService {
  Future<void> sendMessage(
    String uid,
    String message,
    String attachment,
    String attachmentName,
  ) async {
    final timeStamp = Timestamp.now();

    Message newMessage = Message(
      uid: uid,
      content: message,
      time: timeStamp,
      attachment: attachment,
      read: 'false',
      attachmentName: attachmentName, companyRead: 'true',
    );

    FirestoreService().uploadMessage(uid, newMessage);
  }

  Future<void> updateMessageReadStatus(String messageId, String userId) async {
    try {
      await FirestoreService()
          .chatRoom
          .doc(userId)
          .collection('messages')
          .doc(messageId)
          .update({
        'read': true,
      });
    } catch (e) {}
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return FirestoreService()
        .chatRoom
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllChatsStream() {
    return FirestoreService()
        .chatRoom
        .orderBy('updateTime', descending: true)
        .snapshots();
  }
}
