import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String displayName;
  final String softCodesId;
  final String photoUrl;
  final String email;
  final String fcm;
  late DocumentReference document;

  AppUser({
    required this.displayName,
    required this.softCodesId,
    required this.photoUrl,
    required this.email,
    required this.fcm,
    required this.document,
  });

  // Factory constructor to create an AppUser instance from a Firestore document
  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      displayName: data['displayName'] ?? '',
      softCodesId: doc.id,
      photoUrl: data['photoUrl'] ?? '',
      email: data['email'] ?? '',
      fcm: data['fcm'] ?? '',
      document: doc.reference,
    );
  }
}
