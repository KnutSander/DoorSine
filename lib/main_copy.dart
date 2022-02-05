/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 05/02/2022

// Azure Client Secret Value: anG7Q~nwpPGMLthLq_9B_wY7SilSJGNQazQQC

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/pages/testing_page.dart';
import 'package:capstone_project/widgets/app_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

const appID = "d73f28067efd4f2bb80d756a87326e33";

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

