/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 12/10/2021

import 'package:flutter/material.dart';

import 'db/lecturer_db_reformat.dart';
import 'pages/tablet_home_page.dart';
import 'pages/phone_home_page.dart';

void main() {
  runApp(MyApp());
}

// TODO: Come up with App name
// TODO: Create ThemeData variable

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final bool tablet = true;

  final LecturerDB _lecturerDB = LecturerDB();

  @override
  Widget build(BuildContext context) {
    _lecturerDB.init();
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
      home: tablet
          ? const TabletHomePage()
          : const PhoneHomePage(),
    );
  }
}
