import 'package:flutter/material.dart';
import 'package:myapp/models/editscreeninfomodal.dart';
import 'package:myapp/screens/appdata/components/feed_add_dialog.dart';

class EDitScreenWidget extends StatefulWidget {
  final EditScreenInfo? screenInfo;
  const EDitScreenWidget({super.key, this.screenInfo});

  @override
  State<EDitScreenWidget> createState() => _EDitScreenWidgetState();
}

class _EDitScreenWidgetState extends State<EDitScreenWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.screenInfo == null) {
      return Container();
    }
    switch (widget.screenInfo!.category) {
      case 'feed':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(54, 57, 52, 113),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: const Color.fromARGB(56, 0, 0, 0),
                    spreadRadius: 1,
                    // offset: Offset(5, 5),
                    blurStyle: BlurStyle.outer,
                  )
                ]),
            child: Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.screenInfo!.doc['title']),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(),
                  Text(
                    "Description",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GlowingBorderTextField(
                    placeholder: widget.screenInfo!.doc['writeUp'],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.screenInfo!.doc['writeUp']),
                ],
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }
}
