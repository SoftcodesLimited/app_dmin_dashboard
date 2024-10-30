import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/database/database.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';

class DeleteFeedDialog extends StatefulWidget {
  final List<String> imageList;
  final QueryDocumentSnapshot<Object?> document;
  const DeleteFeedDialog(
      {super.key, required this.imageList, required this.document});

  @override
  State<DeleteFeedDialog> createState() => _DeleteFeedDialogState();
}

class _DeleteFeedDialogState extends State<DeleteFeedDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      actions: _isDeleting
          ? []
          : [
              MyCustomButtom(
                conerRadius: 8.0,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
              MyCustomButtom(
                conerRadius: 8.0,
                backgroundColor: const Color.fromARGB(166, 244, 67, 54),
                onPressed: () async {
                  setState(() {
                    _isDeleting = true;
                  });
                  await FirestoreService()
                      .deleteImageFromStorage(widget.imageList);

                  await FirestoreService()
                      .appData
                      .doc('feeds')
                      .collection('feeds')
                      .doc(widget.document.id)
                      .delete();

                  Navigator.of(context).pop();
                },
                child: const Text("Delete"),
              ),
            ],
      title: _isDeleting
          ? const Text('Delete Confirmed')
          : const Text(
              "Confirm Delete",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      content: _isDeleting
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Deleting ...'),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : const Text("Are you sure you want to delete this item?"),
    );
  }
}
