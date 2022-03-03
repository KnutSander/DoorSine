/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PhoneHomePage extends StatefulWidget {
  PhoneHomePage({Key? key, required this.lecturer}) : super(key: key);

  final Lecturer lecturer;

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current Status',
                style: Theme.of(context).textTheme.headline4),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            ElevatedButton(
              child: Text(
                widget.lecturer.busy ? 'Busy' : 'Available',
                style: const TextStyle(fontSize: 35),
              ),
              onPressed: () {
                setState(() {
                  widget.lecturer.busy = !widget.lecturer.busy;
                });
                FirebaseConnector.uploadData(widget.lecturer);
                NotificationService.displayNotification(
                  title: "Test",
                  body: "This is a test"
                );
              },
              style: ButtonStyle(
                  backgroundColor: widget.lecturer.busy
                      ? MaterialStateProperty.all<Color>(Colors.red)
                      : MaterialStateProperty.all<Color>(Colors.green),
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width / 1.5,
                      MediaQuery.of(context).size.height / 10))),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
            ElevatedButton(
              child: Text(
                widget.lecturer.outOfOffice ? 'Out of Office' : 'In Office',
                style: const TextStyle(fontSize: 35),
              ),
              onPressed: () {
                setState(() {
                  widget.lecturer.outOfOffice = !widget.lecturer.outOfOffice;
                });
                FirebaseConnector.uploadData(widget.lecturer);
              },
              style: ButtonStyle(
                  backgroundColor: widget.lecturer.outOfOffice
                      ? MaterialStateProperty.all<Color>(Colors.red)
                      : MaterialStateProperty.all<Color>(Colors.green),
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width / 1.5,
                      MediaQuery.of(context).size.height / 10))),
            )
          ],
        ),
      ),
    );
  }
}
