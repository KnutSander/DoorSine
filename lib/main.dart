/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 12/10/2021

import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone Project',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(title: 'Capstone Project'),
    );
  }
}


