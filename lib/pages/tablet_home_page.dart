/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/pages/tablet_pages/tablet_calendar_page.dart';
import 'package:capstone_project/pages/tablet_pages/tablet_messages_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class TabletHomePage extends StatefulWidget {
  TabletHomePage({Key? key, required this.userdata}) : super(key: key);

  final User? userdata;

  @override
  State<TabletHomePage> createState() => _TabletHomePageState();
}

// TODO: Make app more adaptive, no set sizes

class _TabletHomePageState extends State<TabletHomePage> {
  // Misc properties for the labels
  MaterialStateProperty<Color> disabled =
      MaterialStateProperty.all<Color>(Colors.grey);
  MaterialStateProperty<Size> minLabelSize =
      MaterialStateProperty.all<Size>(const Size(450.0, 100.0));
  TextStyle labelText = const TextStyle(fontSize: 69.0, color: Colors.white);

  // Misc properties of the intractable buttons
  TextStyle buttonText = const TextStyle(fontSize: 42.0);
  MaterialStateProperty<Size> minButtonSize =
      MaterialStateProperty.all<Size>(const Size(370.0, 70.0));

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _lecturer =
        FirebaseFirestore.instance
            .collection('lecturer')
            .doc(widget.userdata!.email)
            .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: _lecturer,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

          DocumentSnapshot<Object?>? lecturerData = snapshot.data;

          // Default profile picture if one isn't specified
          String pictureLink = lecturerData!.get('picture link') != ''
              ? lecturerData.get('picture link')
              : 'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    // Haven't tested if this works or not
                    image: NetworkImage(pictureLink),
                    height: 200.0,
                    width: 200.0,
                  ),
                  Text(
                    lecturerData.get('title') + ' ' + lecturerData.get('name'),
                    style: const TextStyle(fontSize: 80.0),
                  ),
                  Row(
                    // This row will contain busy/available and in/out of office
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        // Busy/Available
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              // Available
                              onPressed: null,
                              child: Text(
                                'Available',
                                style: labelText,
                              ),
                              style: ButtonStyle(
                                backgroundColor: lecturerData.get('busy')
                                    ? disabled
                                    : MaterialStateProperty.all<Color>(
                                        Colors.green),
                                minimumSize: minLabelSize,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              // Busy
                              onPressed: null,
                              child: Text(
                                'Busy',
                                style: labelText,
                              ),
                              style: ButtonStyle(
                                backgroundColor: lecturerData.get('busy')
                                    ? MaterialStateProperty.all<Color>(
                                        Colors.red)
                                    : disabled,
                                minimumSize: minLabelSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        // In/Out of Office
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              // In Office
                              onPressed: null,
                              child: Text(
                                'In Office',
                                style: labelText,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    lecturerData.get('out of office')
                                        ? disabled
                                        : MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                minimumSize: minLabelSize,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              // Out of Office
                              onPressed: null,
                              child: Text(
                                'Out of Office',
                                style: labelText,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    lecturerData.get('out of office')
                                        ? MaterialStateProperty.all<Color>(
                                            Colors.orange)
                                        : disabled,
                                minimumSize: minLabelSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    // This column will contain the options presented
                    //TODO: Add functionality to the buttons
                    //TODO: Make buttons visible based on availability and location
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabletMessagesPage(
                                          lecturerEmail: lecturerData.get('email'),
                                          name: "Student",
                                        )
                                )
                            );
                          },
                          child: Text(
                            'Message',
                            style: buttonText,
                          ),
                          style: ButtonStyle(
                            minimumSize: minButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TabletCalendarPage()
                              )
                            );
                          },
                          child: Text(
                            'Schedule Meeting',
                            style: buttonText,
                          ),
                          style: ButtonStyle(
                            minimumSize: minButtonSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _showStaffInfo(context, lecturerData));
                          },
                          child: Text(
                            'Staff Info',
                            style: buttonText,
                          ),
                          style: ButtonStyle(
                            minimumSize: minButtonSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
  // TODO: Create QR code that opens email when scanned

  Widget _showStaffInfo(BuildContext context, DocumentSnapshot lecturerData) {
    return SimpleDialog(
      title: const Center(child: Text('Staff Info')),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // TODO: Add other info?
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  // Email
                  children: <Widget>[
                    const Expanded(
                        child: Text(
                      'Email:',
                      textAlign: TextAlign.right,
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lecturerData.get('email'),
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  // Office hours
                  children: <Widget>[
                    const Expanded(
                        child: Text(
                      'Office Hours:',
                      textAlign: TextAlign.right,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: Text(lecturerData.get('office hours'))),
                  ],
                ),
              ),
              const Image(
                image: NetworkImage(
                    'https://i.pinimg.com/originals/60/c1/4a/60c14a43fb4745795b3b358868517e79.png'),
                height: 150.0,
                width: 150.0,
              ),
              const Text('Scan QR code for email'),
            ],
          ),
        ),
      ],
    );
  }
}
