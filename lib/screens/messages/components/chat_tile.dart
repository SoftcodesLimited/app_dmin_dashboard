import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/messaging/chat_model.dart';
import 'package:myapp/utils/shimmer_container.dart';
import 'package:myapp/utils/ui_time_functions.dart';

class ChatTile extends StatefulWidget {
  final Chat chat;
  final void Function(Chat value) onTap;

  const ChatTile({super.key, required this.chat, required this.onTap});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String displayMsg = '';
  String image = '';
  String time = '';

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap(widget.chat);
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 38,
            height: 38,
            fit: BoxFit.cover,
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.chat.user != null ? widget.chat.user!.displayName : '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              displayMsg,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.red),
            child: const Text('02',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  void getMessage() async {
    await widget.chat.getLastMessage().then((value) {
      setState(() {
        displayMsg = value;
        image = widget.chat.user!.photoUrl;
        time = UITime().timeInAgo(widget.chat.lastUpdated);
        debugPrint('Image $image');
      });
    });
  }
}

class ChatTileLoading extends StatelessWidget {
  const ChatTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        leading: ShimmerContainer(
          height: 38,
          width: 38,
          borderRadius: BorderRadius.circular(50),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerContainer(
              height: 12,
              width: 80,
              borderRadius: BorderRadius.circular(20),
            ),
            ShimmerContainer(
              height: 10,
              width: 30,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 5,
          ),
          ShimmerContainer(
            height: 10,
            width: 200,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(
            height: 5,
          ),
          ShimmerContainer(
            height: 10,
            width: 100,
            borderRadius: BorderRadius.circular(20),
          ),
        ]));
  }
}
