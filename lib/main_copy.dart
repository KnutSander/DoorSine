/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => FirebaseConnector(),
    builder: (context, _) => DoorSine(),
  ));
}

// TODO: Create ThemeData variable

// Working app name is DoorSine/Door~
class DoorSine extends StatelessWidget {
  DoorSine({Key? key}) : super(key: key);

  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {

        Widget loadPage() {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Something is wrong!')),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage();
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'Capstone Project',
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: const TextTheme(
              bodyText2: TextStyle(
                // Staff Info text
                fontSize: 25.0,
              ),
              headline6: TextStyle(
                // Staff Info header
                fontSize: 30.0,
              ),
            ),
          ),
          home: loadPage(),
        );
      },
    );
  }
}
