import 'package:flutter/cupertino.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/touch_responsive_container.dart';

class AddFeedDialog extends StatefulWidget {
  const AddFeedDialog({super.key});

  @override
  State<AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<AddFeedDialog> {
  final TextEditingController writeUpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomActionDialog(
      actions: [
        Spacer(),
        Spacer(),
        MyCustomButtom(
          conerRadius: 8.0,
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Add"),
        ),
      ],
      title: const Text(
        "Add Feed",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('Write Up'),
          const SizedBox(height: 10),
          CupertinoTextField(
            controller: writeUpController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(149, 42, 45, 62),
                border: Border.all(color: const Color.fromRGBO(52, 73, 94, 1))),
          ),
          const SizedBox(height: 10),
          const Text('Upload photos'),
          const SizedBox(height: 10),
          Center(
            child: TouchResponsiveContainer(
              height: 100,
              width: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromARGB(149, 42, 45, 62),
                  border:
                      Border.all(color: const Color.fromARGB(81, 52, 73, 94))),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Color.fromRGBO(52, 73, 94, 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
