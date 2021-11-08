/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 08/11/2021


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
              const Expanded(
                child: Text(
                  'Available',
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    value: widget.lecturer.busy,
                    onChanged: (bool value) async {
                      setState(() {
                        widget.lecturer.busy = value;
                      });
                      FirebaseConnector.uploadData(widget.lecturer);
                    },
                  ),
                ),
              ),
              const Expanded(child: Text('Busy'))
            ],
          ),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'In Office',
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    value: widget.lecturer.outOfOffice,
                    onChanged: (bool value) async {
                      setState(() {
                        widget.lecturer.outOfOffice = value;
                      });
                      FirebaseConnector.uploadData(widget.lecturer);
                    },
                  ),
                ),
              ),
              const Expanded(child: Text('Out of Office'))
            ],
          ),
        ],
      );
  }
}
