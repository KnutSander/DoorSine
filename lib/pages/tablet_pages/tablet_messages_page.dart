/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/pages/message_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabletMessagesPage extends StatefulWidget{
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