/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/firebase_connector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_widget.dart';

class MessagePage extends StatefulWidget{
  final String sender;
  final String lecturerEmail;

  const MessagePage({Key? key, required this.sender, required this.lecturerEmail}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();

}

class _MessagePageState extends State<MessagePage>{
  final List<Message> _messages = [];
  final _messageController = TextEditingController();
  bool _isWriting = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream;
  AsyncSnapshot<QuerySnapshot> lastSnapshot = const AsyncSnapshot.nothing();

  @override
  initState(){
    super.initState();
    _messageStream = FirebaseFirestore.instance.collection('lecturer').doc(widget.lecturerEmail).collection('messages').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Something went wrong')));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            ),
          );
        }

        if(snapshot.data != null && lastSnapshot != snapshot){
           // print(snapshot.data!.docs.first.toString());
          _messages.clear();
          var docIterator = snapshot.data!.docs.iterator;
          while(docIterator.moveNext()){
            // print(docIterator.current.data().toString());
            var message = docIterator.current;
            _messages.add(Message(text: message.get('text'), sender: message.get('name'), time: message.get('time'),));
          }
          _messages.sort((a, b) => b.time.compareTo(a.time));
        }

        lastSnapshot = snapshot;

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
    var message = Message(text: text, sender: widget.sender, time: Timestamp.now());
    FirebaseConnector.sendMessage(widget.lecturerEmail, message);
  }

}