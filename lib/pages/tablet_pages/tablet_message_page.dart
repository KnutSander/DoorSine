/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:capstone_project/pages/message_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TabletMessagesPage uses MessagePage to send messages to the other side
// of the app
class TabletMessagesPage extends StatefulWidget{
  // Constructor
  const TabletMessagesPage({Key? key, required this.name, required this.lecturerEmail}) : super(key: key);

  // Strings for name and lecturer email
  final String name;
  final String lecturerEmail;

  // Create state function
  @override
  State<StatefulWidget> createState() => _TabletMessagesPageState();
}

// State class all StatefulWidgets use
class _TabletMessagesPageState extends State<TabletMessagesPage>{
  // Main build function
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

  // Displays the page info
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