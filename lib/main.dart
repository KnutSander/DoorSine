/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:capstone_project/widgets/firebase_connector.dart';
import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/widgets/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// App ID used for calling
const appID = "d73f28067efd4f2bb80d756a87326e33";

// Main function
Future<void> main() async {
  // Create and initialise the WidgetsBinding
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app using a ChangeNotifierProvider that
  // looks for changes retrieved from Firebase
  runApp(ChangeNotifierProvider(
    create: (context) => FirebaseConnector(),
    builder: (context, _) => DoorSine(),
  ));
}


// Main App class
class DoorSine extends StatelessWidget {
  // Constructor
  DoorSine({Key? key}) : super(key: key);

  // Initialises the connection to Firebase
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  // Main build function
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {

        // Called in the MaterialApp return
        Widget loadPage() {
          // Display error
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Something is wrong!')),
            );
          }

          // Load LoginPage if everything is alright
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginPage();
          }

          // Show a loading screen when loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            ),
          );
        }

        // Main body of the app is the MaterialApp
        // Everything must be and is inside it
        return MaterialApp(
          title: 'DoorSine',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          home: loadPage(),
        );
      },
    );
  }
}
