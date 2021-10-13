/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 12/10/2021

import 'package:flutter/material.dart';

import 'tablet_home_page.dart';
import 'phone_home_page.dart';

void main() {
  runApp(const MyApp());
}

// TODO: Come up with App name
// TODO: Create ThemeData variable

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final bool tablet = false;

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
      home: tablet
          ? const TabletHomePage()
          : const PhoneHomePage(),
    );
  }
}
