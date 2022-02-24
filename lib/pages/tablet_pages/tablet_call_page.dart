/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/02/2021

import 'dart:async';
import 'package:capstone_project/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TabletCallPage extends StatefulWidget {
  final String lecturerEmail;

  const TabletCallPage({Key? key, required this.lecturerEmail})
      : super(key: key);

  @override
  _TabletCallPageState createState() => _TabletCallPageState();
}

class _TabletCallPageState extends State<TabletCallPage> {

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  Future<void> getPermissions() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Page'),
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
      body: CallPage(channelName: widget.lecturerEmail,)
    );
  }

  Widget _displayPageInfo() {
    return const SimpleDialog(
      title: Center(child: Text('Page Info')),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("On this page you can join a video call with the lecturer"
                "Simply press the Join Call button to join the video chat")
        ),
      ],
    );
  }
}
