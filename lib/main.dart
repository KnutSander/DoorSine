/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 31/10/2021

import 'dart:math';

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/phone_main.dart';
import 'package:capstone_project/pages/testing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/tablet_home_page.dart';
import 'pages/phone_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      ChangeNotifierProvider(
        create: (context) => FirebaseConnector(),
        builder: (context, _) => MyApp(),
      ));
}

// TODO: Come up with App name
// TODO: Create ThemeData variable

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _page = 1; // 0 = tablet, 1 = phone, 2 = testing
  final _random = Random();
  final lecList = getLecturers();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone Project',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          bodyText2: TextStyle( // Staff Info text
            fontSize: 25.0,
          ),
          headline6: TextStyle( // Staff Info header
            fontSize: 30.0,
          ),
        ),
      ),
      home: openPage(),
    );
  }

  Widget openPage() {
    Lecturer lecturer = lecList[_random.nextInt(lecList.length)];
    //Lecturer lecturer = lecList[4];
    if(_page == 0) {
      return TabletHomePage(lecturer: lecturer);
    } else if(_page == 1) {
      return PhoneMain(lecturer: lecturer);
    } else {
      return TestingPage(lecturer: lecturer);
    }
  }
}
