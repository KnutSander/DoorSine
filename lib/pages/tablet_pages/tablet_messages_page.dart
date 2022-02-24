/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 16/02/2022

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
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _displayPageInfo());
              })
        ],
      ),
        body: MessagePage(lecturerEmail: widget.lecturerEmail, sender: widget.name,)
    );
  }

  Widget _displayPageInfo() {
    return const SimpleDialog(
      title: Center(child: Text('Page Info')),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("On this page you can message the lecturer"
                "Simply type a message and wait for them to respond")
        ),
      ],
    );
  }

}