/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/phone_pages/phone_home_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_messages_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_call_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_settings_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_calendar_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class PhoneMain extends StatefulWidget {
  const PhoneMain({Key? key, required this.userdata}) : super(key: key);

  final User? userdata;

  @override
  State<PhoneMain> createState() => _PhoneMainState();
}

class _PhoneMainState extends State<PhoneMain> {
  int _curPage = 0;
  Lecturer lecturer = Lecturer.empty();
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _lecturerData;

  // get the lecturer data in initState, so it doesn't have to reload between page changes
  @override
  initState() {
    super.initState();
    _lecturerData = FirebaseFirestore.instance
        .collection('lecturer')
        .doc(widget.userdata!.email)
        .snapshots();
  }

  // Changes BottomNavigationBar selection
  void _changeView(int index) {
    setState(() {
      _curPage = index;
    });
  }

  // Swaps body based on BottomNavigationBar selection
  Widget _changeBody() {
    if (_curPage == 0) {
      return PhoneHomePage(lecturer: lecturer);
    } else if (_curPage == 1) {
      return PhoneMessagePage(lecturer: lecturer);
    } else if (_curPage == 2) {
      return PhoneCallPage(
        lecturerEmail: lecturer.email,
      );
    } else if (_curPage == 3) {
      return const PhoneCalendarPage();
    } else {
      return PhoneSettingsPage(lecturer: lecturer);
    }
  }

  @override
  Widget build(BuildContext context) {
    _changeView(_curPage);

    return StreamBuilder<DocumentSnapshot>(
        stream: _lecturerData,
        builder:
            (BuildContext builder, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          Map<String, dynamic> data =
              lecturerData!.data() as Map<String, dynamic>;

          // Got around the problem of the lecturer being updated to often by
          // limiting updates based on changes
          if ((lecturer.busy != data['busy'] ||
                  lecturer.outOfOffice != data['out of office']) ||
              lecturer.email == '') {
            lecturer.fromMap(data);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                lecturerData.get('title') + ' ' + lecturerData.get('name'),
              ),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _displayPageInfo());
                    })
              ],
            ),
            body: _changeBody(),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: "Home",
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.message),
                  label: "Messages",
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.call),
                  label: "Call",
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_today),
                  label: "Calendar",
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: "Settings",
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
              onTap: _changeView,
              currentIndex: _curPage,
            ),
          );
        });
  }

  Widget _displayPageInfo() {
    return SimpleDialog(
      title: const Center(child: Text('Page Info')),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _getPageText(),
        ),
      ],
    );
  }

  Text _getPageText() {
    switch (_curPage) {
      case 0:
        return const Text("On this page you can change your availability\n"
            "Simply press one of the buttons to change your availability");
      case 1:
        return const Text(
            "On this page you can respond to messages from people outside your office");
      case 2:
        return const Text(
            "On this page you can talk with people outside of your office\n"
            "Simply press the Join Call button to join the video chat");
      case 3:
        return const Text(
            "On this page you can see your calendar that has been imported\n"
            "This is what people trying to book meetings with you will see\n"
            "Simply add events to your calendar as normal and they will appear here");
      default:
        return const Text("On this page you can change your display information\n"
            "Simply change what you need and press the update button to update the information");
    }
  }
}
