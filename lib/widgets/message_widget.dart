/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Create a more substantial class than just returning a Container with Text
// Needs animations and more styling, could provide a name in the future perhaps
class Message extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp time;

  const Message({Key? key, required this.text, required this.sender,
    required this.time}) : super(key: key);

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