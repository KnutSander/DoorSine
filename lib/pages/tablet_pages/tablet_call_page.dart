/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2021

// Imports
import 'dart:async';
import 'package:capstone_project/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// TabletCallPage class uses the CallPage class to call the other side
// of the app
class TabletCallPage extends StatefulWidget {
  // Constructor
  const TabletCallPage({Key? key, required this.lecturerEmail})
      : super(key: key);

  // Lecturer email
  final String lecturerEmail;

  // Create state function
  @override
  _TabletCallPageState createState() => _TabletCallPageState();
}

// State class all StatefulWidgets use
class _TabletCallPageState extends State<TabletCallPage> {
  // Initialise function
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  // Main build function
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
                      builder: (BuildContext context) => _displayPageInfo());
                })
          ],
        ),
        body: CallPage(
          channelName: widget.lecturerEmail,
        ));
  }

  // Get permissions to use camera and microphone
  Future<void> getPermissions() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

  // Wait for the permission confirmation
  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
  }

  // Displays the page info
  Widget _displayPageInfo() {
    return const SimpleDialog(
      title: Center(child: Text('Page Info')),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "On this page you can join a video call with the lecturer"
                "Simply press the Join Call button to join the video chat")),
      ],
    );
  }
}
