/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// The wrapper class for messages in the app
class Message extends StatelessWidget {
  // Constructor
  const Message({Key? key, required this.text, required this.sender,
    required this.time}) : super(key: key);

  // Message info
  final String text;
  final String sender;
  final Timestamp time;

  // Build method, creates the message object
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: Theme.of(context).textTheme.headline5),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
              child: Text(text)
          )
        ],
      ),
    );
  }

}
