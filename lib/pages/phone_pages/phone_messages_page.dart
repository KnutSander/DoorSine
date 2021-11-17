/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 17/11/2021

import 'package:flutter/material.dart';

class PhoneMessagePage extends StatefulWidget{
  const PhoneMessagePage({Key? key}) : super(key: key);

  @override
  State<PhoneMessagePage> createState() => _PhoneMessagePageState();
}

class _PhoneMessagePageState extends State<PhoneMessagePage>{
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

// TODO: Create a more substantial class than just returning a Container with Text
// Needs animations and more styling, could provide a name in the future perhaps
class Message extends StatelessWidget {
  final String text;

  const Message({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text),
    );
  }

}