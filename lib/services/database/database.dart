import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/messaging/message_model.dart';

class FirestoreService {
  final CollectionReference appData =
      FirebaseFirestore.instance.collection("AppData");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("ChatRooms");
  final CollectionReference applications =
      FirebaseFirestore.instance.collection("Applications");
  final CollectionReference orders =
      FirebaseFirestore.instance.collection("Orders");
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('Appointments');
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');
  final CollectionReference sliderData =
      FirebaseFirestore.instance.collection("slider");

  Future<void> uploadMessage(String chatRoomId, Message message) async {
    final chatRoomRef = chatRoom.doc(chatRoomId);
    await chatRoomRef.collection('messages').add(message.toMap());
    await chatRoomRef.set(
      {
        'updateTime': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> pushOrder(dynamic order) async {
    await orders
        .doc(order.customer.softCodesId)
        .collection('orders')
        .add(order.toMap());
  }
}
