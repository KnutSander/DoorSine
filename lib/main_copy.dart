/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 02/12/2021

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/pages/testing_page.dart';
import 'package:capstone_project/widgets/app_theme.dart';
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

// Working app name is DoorSine/Door~
class DoorSine extends StatelessWidget {
  DoorSine({Key? key}) : super(key: key);

  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    //return const TestingPage();

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
          theme: AppTheme.appTheme,
          home: loadPage(),
        );
      },
    );
  }
}

