/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2021

// imports
import 'dart:async';
import 'package:capstone_project/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// PhoneCallPage class uses the CallPage class to call the other side
// of the app
class PhoneCallPage extends StatefulWidget {
  // Constructor
  const PhoneCallPage({Key? key, required this.lecturerEmail})
      : super(key: key);

  // Lecturer email
  final String lecturerEmail;

  // Create state function
  @override
  _PhoneCallPageState createState() => _PhoneCallPageState();
}

// State class all StatefulWidgets use
class _PhoneCallPageState extends State<PhoneCallPage> {

  // Initialise function
  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  // Main build finction
  @override
  Widget build(BuildContext context) {
    return CallPage(channelName: widget.lecturerEmail);
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
}
