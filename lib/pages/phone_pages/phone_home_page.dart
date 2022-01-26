/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';

import 'package:flutter/material.dart';

class PhoneHomePage extends StatefulWidget {
  PhoneHomePage({Key? key, required this.lecturer}) : super(key: key);

  final Lecturer lecturer;

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Available',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: widget.lecturer.busy,
                  onChanged: (bool value) {
                    setState(() {
                      widget.lecturer.busy = value;
                    });
                    FirebaseConnector.uploadData(widget.lecturer);
                  },
                ),
              ),
            ),
            Expanded(
                child: Text(
              'Busy',
              style: Theme.of(context).textTheme.headline5,
            ))
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'In Office',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: widget.lecturer.outOfOffice,
                  onChanged: (bool value) {
                    setState(() {
                      widget.lecturer.outOfOffice = value;
                    });
                    FirebaseConnector.uploadData(widget.lecturer);
                  },
                ),
              ),
            ),
            Expanded(child: Text('Out of Office', style: Theme.of(context).textTheme.headline5,))
          ],
        ),
      ],
    );
  }
}
