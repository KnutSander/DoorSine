/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 10/10/2021

import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Staff Name',
              style: TextStyle(fontSize: 80.0),
            ),
            Row( // This row will contain busy/available and in/out of office
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column( // Busy/Available
                  children: const <Widget>[
                    ElevatedButton( // Available
                      onPressed:  null,
                      child: Text('Available'),
                    ),
                    ElevatedButton( // Busy
                      onPressed: null,
                      child: Text('Busy'),
                    ),
                  ],
                ),
                Column( // In/Out of Office
                  children: const <Widget>[
                    ElevatedButton( // In Office
                      onPressed: null,
                      child: Text('In Office'),
                    ),
                    ElevatedButton( // Out of Office
                      onPressed: null,
                      child: Text('Out of Office'),
                    ),
                  ],
                ),
              ],
            ),
            Column( // This column will contain the options presented
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Message'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Schedule Meeting'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Staff Info'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
