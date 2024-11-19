import 'package:cloud_firestore/cloud_firestore.dart';

class EditScreenInfo {
  QueryDocumentSnapshot<Object?> doc;
  String category;
  EditScreenInfo({required this.doc, required this.category});
}
