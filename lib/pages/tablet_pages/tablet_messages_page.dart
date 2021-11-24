
import 'package:capstone_project/widgets/message_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabletMessagesPage extends StatefulWidget{
  const TabletMessagesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabletMessagesPageState();

}

class _TabletMessagesPageState extends State<TabletMessagesPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
        body: const MessagePage()
    );
  }

}

// class TabletMessagesPage extends StatelessWidget{
//   const TabletMessagesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MessagePage();
//   }
//
// }