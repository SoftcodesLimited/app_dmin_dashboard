
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTextBox extends StatefulWidget {
  final void Function(String message) onSendMessage;

  const ChatTextBox({super.key, required this.onSendMessage});

  @override
  State<ChatTextBox> createState() => _ChatTextBoxState();
}

class _ChatTextBoxState extends State<ChatTextBox> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(17, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _messageController,
              decoration: const BoxDecoration(),
              placeholder: 'Type Here',
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              expands: true,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                widget.onSendMessage(message);
                _messageController.clear(); // Clear the text box after sending
              }
            },
            icon: const Icon(CupertinoIcons.paperplane),
          )
        ],
      ),
    );
  }
}
