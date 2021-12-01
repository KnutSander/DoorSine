/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/firebase_connector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/message_widget.dart';

class MessagePage extends StatefulWidget {
  final String sender;
  final String lecturerEmail;

  const MessagePage(
      {Key? key, required this.sender, required this.lecturerEmail})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Message> _messages = [];
  final _messageController = TextEditingController();
  bool _isWriting = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream;
  AsyncSnapshot<QuerySnapshot> lastSnapshot = const AsyncSnapshot.nothing();

  @override
  initState() {
    super.initState();
    _messageStream = FirebaseFirestore.instance
        .collection('lecturer')
        .doc(widget.lecturerEmail)
        .collection('messages')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _messageStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          // Updates the messages if there is a new ones
          if (snapshot.data != null && lastSnapshot != snapshot) {
            _messages.clear();
            var docIterator = snapshot.data!.docs.iterator;
            while (docIterator.moveNext()) {
              var message = docIterator.current;
              _messages.add(Message(
                text: message.get('text'),
                sender: message.get('name'),
                time: message.get('time'),
              ));
            }
            _messages.sort((a, b) => b.time.compareTo(a.time));
          }

          lastSnapshot = snapshot;

          return Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (_, int index) {
                    return Column(
                      crossAxisAlignment:
                      (_messages[index].sender == widget.sender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start),
                      children: [
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: MediaQuery.of(context).size.width/1.9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (_messages[index].sender == widget.sender
                                ? Colors.grey[300]
                                : Colors.redAccent),
                          ),
                          padding: const EdgeInsets.all(8),
                          alignment: (_messages[index].sender == widget.sender
                              ? Alignment.topRight
                              : Alignment.topLeft),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _messages[index].sender,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  _messages[index].text,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        const Padding(padding: EdgeInsets.only(bottom: 8)),
                      ],
                    );
                  },
                ),
              ),
              _createMessagingField(),
              const Padding(padding: EdgeInsets.only(bottom: 8))
            ],
          );
        });
  }

  Widget _createMessagingField() {
    return Row(
      children: <Widget>[
        Flexible(
            child: TextField(
          controller: _messageController,
          onChanged: (String text) {
            setState(() {
              _isWriting = text.isNotEmpty;
            });
          },
          onSubmitted: _isWriting ? _sendMessage : null,
        )),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed:
              _isWriting ? () => _sendMessage(_messageController.text) : null,
        )
      ],
    );
  }

  void _sendMessage(String text) {
    _messageController.clear();
    setState(() {
      _isWriting = false;
    });
    var message =
        Message(text: text, sender: widget.sender, time: Timestamp.now());
    FirebaseConnector.sendMessage(widget.lecturerEmail, message);
  }
}
