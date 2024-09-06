/*
 +===================================================+
 |   Message Modal                                   |
 |   @Author:  by Frost Edson                        |
 |   @Copyright: SoftCodes.dev                       |
 |   @Licenses: SoftCodes.dev                        |
 +===================================================+


*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uid;
  final String content;
  final Timestamp time;
  final String attachment;
  final String read;
  final String attachmentName;
  final String companyRead;

  late DocumentSnapshot document;

  Message({
    required this.uid,
    required this.content,
    required this.time,
    required this.attachment,
    required this.attachmentName,
    required this.read,
    required this.companyRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'content': content,
      'time': time,
      'attachment': attachment,
      'read': read,
      'attachmentName': attachmentName,
      'companyRead': companyRead,
    };
  }
}
