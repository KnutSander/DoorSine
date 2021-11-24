/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:flutter/cupertino.dart';

// TODO: Create a more substantial class than just returning a Container with Text
// Needs animations and more styling, could provide a name in the future perhaps
class Message extends StatelessWidget {
  final String text;
  final String sender;

  const Message({Key? key, required this.text, required this.sender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text),
    );
  }

}