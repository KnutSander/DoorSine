/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'dart:async';

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/phone_pages/phone_calendar_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_home_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_messages_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneMain extends StatefulWidget {
  PhoneMain({Key? key, required this.lecturer}) : super(key: key);

  Lecturer lecturer;

  @override
  State<PhoneMain> createState() => _PhoneMainState();
}

class _PhoneMainState extends State<PhoneMain> {
  int _curPage = 0;
  late Widget _body;

  // Changes BottomNavigationBar selection
  void _changeView(int index) {
    setState(() {
      _curPage = index;
    });
  }

  // Swaps body based on BottomNavigationBar selection
  Widget _changeBody(FutureOr<void> Function(Lecturer lecturer) futureOr) {
    if (_curPage == 0) {
      return PhoneHomePage(
        lecturer: widget.lecturer,
        uploadData: futureOr,
      );
    } else if (_curPage == 1) {
      return const PhoneMessagePage();
    } else if (_curPage == 2) {
      return const PhoneCalendarPage();
    } else {
      return const PhoneSettingsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    _changeView(_curPage);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lecturer.title + ' ' + widget.lecturer.name,
        ),
      ),
      body: Consumer<FirebaseConnector>(
        builder: (context, appState, _) => Center(
          child: _changeBody(appState.uploadData),
        ),
      ),
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
  }
}
