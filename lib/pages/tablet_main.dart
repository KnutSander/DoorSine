/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 16/02/2022

import 'package:capstone_project/pages/tablet_pages/tablet_calendar_page.dart';
import 'package:capstone_project/pages/tablet_pages/tablet_call_page.dart';
import 'package:capstone_project/pages/tablet_pages/tablet_messages_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class TabletMain extends StatefulWidget {
  const TabletMain({Key? key, required this.userdata}) : super(key: key);

  final User? userdata;

  @override
  State<TabletMain> createState() => _TabletMainState();
}

class _TabletMainState extends State<TabletMain> {
  MaterialStateProperty<Color> disabled =
      MaterialStateProperty.all<Color>(Colors.grey);

  DocumentSnapshot<Object?>? lecturerData;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _lecturer =
        FirebaseFirestore.instance
            .collection('lecturer')
            .doc(widget.userdata!.email)
            .snapshots();

    // Used to access screen size
    MediaQueryData queryData = MediaQuery.of(context);
    // Misc properties for the labels
    // Initialised inside the build function to access queryData
    MaterialStateProperty<Size> minLabelSize = MaterialStateProperty.all<Size>(
        Size(queryData.size.width / 2.5, queryData.size.height / 7));
    TextStyle labelText = TextStyle(
        fontSize: ((queryData.size.width * queryData.size.height) / 15000),
        color: Colors.white);

    // Misc properties of the intractable buttons
    MaterialStateProperty<Size> minButtonSize = MaterialStateProperty.all<Size>(
        Size(queryData.size.width / 3, queryData.size.height / 10));
    TextStyle buttonText = TextStyle(
        fontSize: (queryData.size.width * queryData.size.height) / 22000);

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

          lecturerData = snapshot.data;

          // Default profile picture if one isn't specified
          String pictureLink = lecturerData!.get('picture link') != ''
              ? lecturerData!.get('picture link')
              : 'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';

          // TODO: Hide buttons based on lecturer availability and location
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: <Widget>[
                  Image(
                    image: NetworkImage(pictureLink),
                    height: queryData.size.height / 4,
                    width: queryData.size.width / 4,
                  ),
                  Text(
                    lecturerData!.get('title') +
                        ' ' +
                        lecturerData!.get('name'),
                    style: TextStyle(
                        fontSize:
                            (queryData.size.width * queryData.size.height) /
                                15000),
                  ),
                  Text(
                    lecturerData!.get('office number'),
                    style: TextStyle(
                        fontSize:
                            (queryData.size.width * queryData.size.height) /
                                30000),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _busyOrAvailableWidgets(
                          lecturerData, minLabelSize, labelText),
                      _inOrOutOfOfficeWidget(
                          lecturerData, minLabelSize, labelText)
                    ],
                  ),
                  _messageAndCallButtons(
                      lecturerData, minButtonSize, buttonText),
                  _meetingAndInfoButtons(
                      lecturerData!, minButtonSize, buttonText)
                ],
              ),
            ),
          );
        });
  }

  Widget _busyOrAvailableWidgets(DocumentSnapshot<Object?>? lecturerData,
      MaterialStateProperty<Size> minLabelSize, TextStyle labelText) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              'Available',
              style: labelText,
            ),
            style: ButtonStyle(
              backgroundColor: lecturerData!.get('busy')
                  ? disabled
                  : MaterialStateProperty.all<Color>(Colors.green),
              minimumSize: minLabelSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              'Busy',
              style: labelText,
            ),
            style: ButtonStyle(
              backgroundColor: lecturerData.get('busy')
                  ? MaterialStateProperty.all<Color>(Colors.red)
                  : disabled,
              minimumSize: minLabelSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inOrOutOfOfficeWidget(DocumentSnapshot<Object?>? lecturerData,
      MaterialStateProperty<Size> minLabelSize, TextStyle labelText) {
    return Column(
      // In/Out of Office
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              'In Office',
              style: labelText,
            ),
            style: ButtonStyle(
              backgroundColor: lecturerData!.get('out of office')
                  ? disabled
                  : MaterialStateProperty.all<Color>(Colors.green),
              minimumSize: minLabelSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              'Out of Office',
              style: labelText,
            ),
            style: ButtonStyle(
              backgroundColor: lecturerData.get('out of office')
                  ? MaterialStateProperty.all<Color>(Colors.red)
                  : disabled,
              minimumSize: minLabelSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageAndCallButtons(DocumentSnapshot<Object?>? lecturerData,
      MaterialStateProperty<Size> minButtonSize, TextStyle buttonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabletMessagesPage(
                            lecturerEmail: lecturerData!.get('email'),
                            name: "Student",
                          )));
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
                      builder: (context) => TabletCallPage(
                        lecturerEmail: lecturerData!.get('email'),
                      )));
            },
            child: Text(
              'Call',
              style: buttonText,
            ),
            style: ButtonStyle(
              minimumSize: minButtonSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _meetingAndInfoButtons(DocumentSnapshot<Object?> lecturerData,
      MaterialStateProperty<Size> minButtonSize, TextStyle buttonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabletCalendarPage(
                            userdata: widget.userdata,
                            lecturerData: lecturerData,
                          )));
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
    );
  }

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
            ],
          ),
        ),
      ],
    );
  }
}
