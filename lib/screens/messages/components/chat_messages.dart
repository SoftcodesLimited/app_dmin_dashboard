import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/messaging/chat_model.dart';
import 'package:myapp/screens/messages/components/chat_text_box.dart';
import 'package:myapp/screens/messages/components/chatbubble.dart';
import 'package:myapp/utils/ui_time_functions.dart';

class Messages extends StatefulWidget {
  final Chat? chat;

  const Messages({super.key, this.chat});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 4, 29, 49),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Color.fromARGB(143, 0, 0, 0),
                BlendMode.darken,
              ),
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          child: widget.chat == null
              ? Container(height: MediaQuery.of(context).size.height * 0.8)
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder(
                        stream: widget.chat!.downloadMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          } else {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ListView(
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      final document =
                                          snapshot.data!.docs[index];
                                      final previousDocIndex = index - 1;

                                      final previousDoc = previousDocIndex >= 0
                                          ? snapshot
                                              .data!.docs[previousDocIndex]
                                          : null;

                                      final nextDocIndex = index + 1;

                                      final nextDoc = nextDocIndex <
                                              snapshot.data!.docs.length
                                          ? snapshot.data!.docs[nextDocIndex]
                                          : null;

                                      final isNextViewer = nextDoc != null &&
                                          nextDoc['uid'] ==
                                              widget.chat!.softcodesId;
                                      final isNextSender = nextDoc != null &&
                                          nextDoc['uid'] !=
                                              widget.chat!.softcodesId;

                                      Viewer viewer;
                                      if (document['uid'] ==
                                          widget.chat!.softcodesId) {
                                        viewer = isNextViewer
                                            ? Viewer.recieverOther
                                            : Viewer.reciever;
                                      } else {
                                        viewer = isNextSender
                                            ? Viewer.senderOther
                                            : Viewer.sender;
                                      }

                                      final date = document['time'];
                                      final previousDate = previousDoc?['time'];

                                      // Display the date header if it's the first message or the date is different from the previous message
                                      final isFirstMessage = index == 0;
                                      final isDifferentDay = previousDate ==
                                              null ||
                                          UITime().timeAccordingToWeek(date) !=
                                              UITime().timeAccordingToWeek(
                                                  previousDate);

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Add the date header for the first message or when the day changes
                                          if (isFirstMessage || isDifferentDay)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Center(
                                                child: Text(
                                                  '------- ${UITime().timeAccordingToWeek(date)}-----',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          if (document['attachment'] != null &&
                                              document['attachment'] != '')
                                            chatBubbleWithAttachment(
                                                context,
                                                viewer,
                                                document['content'],
                                                document['attachmentName'],
                                                document['read'] == true)
                                          else
                                            ChatBubble(
                                                context,
                                                viewer,
                                                document['content'],
                                                document['read'] == true),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No messages available'),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
        ),
        Positioned(
          bottom: 10,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 38, 59),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: ChatTextBox(
                onSendMessage: sendMessage,
              ),
            ),
          ),
        )
      ],
    );
  }

  void sendMessage(String message) {
    widget.chat!.sendMessage(message, '', '');
  }
}
