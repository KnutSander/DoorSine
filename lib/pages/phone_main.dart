/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'package:capstone_project/pages/phone_pages/phone_calendar_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_home_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_messages_page.dart';
import 'package:capstone_project/pages/phone_pages/phone_settings_page.dart';
import 'package:flutter/material.dart';

class PhoneMain extends StatefulWidget{
  const PhoneMain({Key? key}) : super(key: key);

  @override
  State<PhoneMain> createState() => _PhoneMainState();

}

class _PhoneMainState extends State<PhoneMain>{

  int _curPage = 0;
  late Widget _body;

  // Changes BottomNavigationBar selection
  void _changeView(int index){
    setState(() {
      _curPage = index;
      _body = _changeBody();
    });
  }

  // Swaps body based on BottomNavigationBar selection
  Widget _changeBody(){
    if(_curPage == 0) {
      return const PhoneHomePage();
    } else if(_curPage == 1) {
      return const PhoneMessagePage();
    } else if(_curPage == 2) {
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
        title: const Text('Staff Name'),
      ),
      body: Center(
        child: _body,
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