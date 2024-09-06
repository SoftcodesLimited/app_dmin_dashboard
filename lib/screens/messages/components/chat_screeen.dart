import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/models/messaging/chat_model.dart';
import 'package:myapp/screens/messages/components/chat_messages.dart';

class ChatWidget extends StatefulWidget {
  final Chat? chat;

  const ChatWidget({super.key, this.chat});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.chat != null
        ? Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: secondaryColor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/images/aisha.jpg",
                          fit: BoxFit.cover,
                          height: 38,
                          width: 38,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(widget.chat?.user?.displayName ?? 'Unknown')
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Messages(chat: widget.chat),
              ),
            ]),
          )
        : Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(143, 0, 0, 0),
                  BlendMode.darken,
                ),
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
          );
  }
}
