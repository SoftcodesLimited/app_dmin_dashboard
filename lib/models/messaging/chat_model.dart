import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/messaging/message_model.dart';
import 'package:myapp/models/users/app_user.dart';
import 'package:myapp/services/database/database.dart';

class Chat {
  final String softcodesId;
  final DocumentSnapshot document;
  final Timestamp lastUpdated;
  AppUser? user;

  Chat({
    required this.softcodesId,
    required this.document,
    required this.lastUpdated,
    this.user,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    // Create a Chat instance without the user

    final chat = Chat(
      softcodesId: doc.id,
      document: doc,
      lastUpdated: doc['updateTime'] as Timestamp,
    );
    //user = AppUser(displayName: '', softCodesId: '', photoUrl:'', email:'', fcm: '', document: doc.reference);
    // Fetch the user data asynchronously and return a Chat with the user
    chat._initializeUser();
    return chat;
  }

  Future<void> _initializeUser() async {
    try {
      // Replace 'users' with your actual collection name
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(softcodesId)
          .get();

      if (userDoc.exists) {
        final user = AppUser.fromDoc(userDoc);
        this.user = user;
      }
    } catch (e) {
      print('Failed to fetch user: $e');
    }
  }

  Future<String> getLastMessage() async {
    final messagesCollection = document.reference.collection('messages');
    final querySnapshot = await messagesCollection
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastMessageDoc = querySnapshot.docs.first;
      return lastMessageDoc['content'] ?? '';
    }

    return 'No messages yet';
  }

  Stream<QuerySnapshot> downloadMessages() {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(softcodesId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(
    String message,
    String attachment,
    String attachmentName,
  ) async {
    final timeStamp = Timestamp.now();

    Message newMessage = Message(
      uid: 'Softcodes',
      content: message,
      time: timeStamp,
      attachment: attachment,
      read: 'false',
      attachmentName: attachmentName,
      companyRead: 'true',
    );

    FirestoreService().uploadMessage(softcodesId, newMessage);
  }


}
