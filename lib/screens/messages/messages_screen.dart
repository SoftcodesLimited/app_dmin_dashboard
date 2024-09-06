import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/messaging/chat_model.dart';
import 'package:myapp/utils/responsive.dart';
import 'package:myapp/screens/dashboard/components/header.dart';
import 'package:myapp/screens/messages/components/chat_list.dart';
import 'package:myapp/screens/messages/components/chat_screeen.dart';

import '../../utils/constants.dart';

class MessagesScreen extends StatelessWidget {
  final ValueNotifier<Chat?> chatNotifier = ValueNotifier<Chat?>(null);

  MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: 'Chats',
              options: [
                HeaderOption(
                  title: "New Chat",
                  icon: "assets/icons/new-chat.svg",
                  index: 1,
                ),
                HeaderOption(
                  title: "Select",
                  icon: "assets/icons/select-multiple.svg",
                  index: 1,
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ChatList(
                    height: MediaQuery.of(context).size.height * 0.9,
                    chatNotifier: chatNotifier,
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 5,
                    child: ValueListenableBuilder<Chat?>(
                      valueListenable: chatNotifier,
                      builder: (context, chat, _) {
                        return ChatWidget(chat: chat);
                      },
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
