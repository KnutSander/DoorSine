/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_widget.dart';

class MessagePage extends StatefulWidget{
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();

}

class _MessagePageState extends State<MessagePage>{
  final List<Message> _messages = [];
  final _messageController = TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
            reverse: true,
          ),
        ),
        const Divider(height: 10),
        _createMessagingField(),
      ],
    );
  }

  Widget _createMessagingField(){
    return Row(
      children: <Widget>[
        Flexible(
            child: TextField(
              controller: _messageController,
              onChanged: (String text){
                setState(() {
                  _isWriting = text.isNotEmpty;
                });
              },
              onSubmitted: _isWriting ? _sendMessage : null,
            )
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _isWriting ? () => _sendMessage(_messageController.text) : null,
        )
      ],
    );
  }

  void _sendMessage(String text){
    _messageController.clear();
    setState(() {
      _isWriting = false;
    });
    var message = Message(text: text);
    setState(() {
      _messages.insert(0, message);
    });
  }

}