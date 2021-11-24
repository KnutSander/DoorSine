/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/widgets/message_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabletMessagesPage extends StatefulWidget{
  // Placeholder name for now, will be queried later
  final String name;
  final String lecturerEmail;

  const TabletMessagesPage({Key? key, required this.name, required this.lecturerEmail}) : super(key: key);

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
        body: MessagePage(lecturerEmail: widget.lecturerEmail, sender: widget.name,)
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