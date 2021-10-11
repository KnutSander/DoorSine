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


// TODO: Make app more adaptive, less set sizes

class _HomePageState extends State<HomePage> {

  bool busy = false;
  bool inOffice = false;

  // Misc properties for the labels
  MaterialStateProperty<Color> disabled = MaterialStateProperty.all<Color>(Colors.grey);
  MaterialStateProperty<Size> minLabelSize = MaterialStateProperty.all<Size>(const Size(450.0, 100.0));
  TextStyle labelText = const TextStyle(fontSize: 69.0, color: Colors.white);

  // Misc properties of the intractable buttons
  TextStyle buttonText = const TextStyle(fontSize: 42.0);
  MaterialStateProperty<Size> minButtonSize = MaterialStateProperty.all<Size>(const Size(370.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: NetworkImage('https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
              height: 200.0,
              width: 200.0,
            ),
            const Text(
              'Staff Name',
              style: TextStyle(fontSize: 80.0),
            ),
            Row( // This row will contain busy/available and in/out of office
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column( // Busy/Available
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton( // Available
                        onPressed:  null,
                        child: Text(
                          'Available',
                          style: labelText,
                        ),
                        style: ButtonStyle(
                          backgroundColor: busy
                              ? disabled
                              : MaterialStateProperty.all<Color>(Colors.green),
                          minimumSize: minLabelSize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton( // Busy
                        onPressed: null,
                        child: Text(
                          'Busy',
                          style: labelText,
                        ),
                        style: ButtonStyle(
                          backgroundColor: busy
                              ? MaterialStateProperty.all<Color>(Colors.red)
                              : disabled,
                          minimumSize: minLabelSize,
                        ),
                      ),
                    ),
                  ],
                ),
                Column( // In/Out of Office
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton( // In Office
                        onPressed: null,
                        child: Text(
                          'In Office',
                          style: labelText,
                        ),
                        style: ButtonStyle(
                          backgroundColor: inOffice
                              ? MaterialStateProperty.all<Color>(Colors.blue)
                              : disabled,
                          minimumSize: minLabelSize,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton( // Out of Office
                        onPressed: null,
                        child: Text(
                          'Out of Office',
                          style: labelText,
                        ),
                        style: ButtonStyle(
                          backgroundColor: inOffice
                              ? disabled
                              : MaterialStateProperty.all<Color>(Colors.orange),
                          minimumSize: minLabelSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column( // This column will contain the options presented
              //TODO: Add functionality to the buttons
              //TODO: Make buttons visible based on availability and location
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OutlinedButton(
                    onPressed: () {},
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
                    onPressed: () {},
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
                    onPressed: () {},
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
  }
}
