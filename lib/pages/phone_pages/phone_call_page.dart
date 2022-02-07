/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 07/02/2021

import 'dart:async';
import 'package:capstone_project/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneCallPage extends StatefulWidget {
  final String lecturerEmail;

  const PhoneCallPage({Key? key, required this.lecturerEmail}) : super(key: key);

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
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text(
                'Agora Group Video Call Demo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: MaterialButton(
                  onPressed: onJoin,
                  height: 40,
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Join',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  Future<void> onJoin() async {

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