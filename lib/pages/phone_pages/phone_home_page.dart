/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'dart:async';

import 'package:capstone_project/models/lecturer.dart';
import 'package:flutter/material.dart';

class PhoneHomePage extends StatefulWidget {
  PhoneHomePage({Key? key, required this.lecturer, required this.uploadData})
      : super(key: key);

  Lecturer lecturer;
  final FutureOr<void> Function(Lecturer lecturer) uploadData;

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    onChanged: (bool value) {
                      setState(() {
                        widget.lecturer.busy = value;
                      });
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
                    value: widget.lecturer.inOffice,
                    onChanged: (bool value) {
                      setState(() {
                        widget.lecturer.inOffice = value;
                      });
                    },
                  ),
                ),
              ),
              const Expanded(child: Text('Out of Office'))
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: const Text("Upload changes"),
                onPressed: () async {
                  await widget.uploadData(widget.lecturer);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
