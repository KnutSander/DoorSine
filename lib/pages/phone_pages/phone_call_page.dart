/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 10/02/2021

import 'dart:async';
import 'package:capstone_project/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneCallPage extends StatefulWidget {
  final String lecturerEmail;

  const PhoneCallPage({Key? key, required this.lecturerEmail})
      : super(key: key);

  @override
  _PhoneCallPageState createState() => _PhoneCallPageState();
}

class _PhoneCallPageState extends State<PhoneCallPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Join Call',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            MaterialButton(
              onPressed: _joinCall,
              height: 80,
              color: Colors.green[700],
              shape: const CircleBorder(),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinCall() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelName: widget.lecturerEmail),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
