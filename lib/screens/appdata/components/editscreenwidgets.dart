import 'package:flutter/material.dart';
import 'package:myapp/models/editscreeninfomodal.dart';
import 'package:myapp/screens/appdata/components/feededitwidget.dart';

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
        return FeedEditWidget(doc: widget.screenInfo!.doc);

      default:
        return Container();
    }
  }
}
