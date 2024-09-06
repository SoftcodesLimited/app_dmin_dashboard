import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/models/messaging/chat_model.dart';
import 'package:myapp/screens/messages/components/chat_tile.dart';
import 'package:myapp/services/messages/chat_service.dart';

class ChatList extends StatelessWidget {
  final double height;
  final ValueNotifier<Chat?> chatNotifier;

  const ChatList({super.key, required this.height, required this.chatNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondaryColor,
      ),
      child: SizedBox(
        height: height,
        child: StreamBuilder<QuerySnapshot>(
          stream: ChatService().getAllChatsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return const Column(
                    children: [
                      ChatTileLoading(),
                      Divider(),
                    ],
                  );
                },
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No chats available'));
            }

            List<QueryDocumentSnapshot> chatRooms = snapshot.data!.docs;

            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                Chat chat = Chat.fromDoc(chatRooms[index]);
                return Column(
                  children: [
                    ChatTile(
                      chat: chat,
                      onTap: (selectedChat) {
                        chatNotifier.value = selectedChat;
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
