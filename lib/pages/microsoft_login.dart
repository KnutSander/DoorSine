/// IMPORTED FOR TESTING PURPOSES ONLY
/// I TAKE NO CREDIT FOR THE CREATION OF THIS FILE
/// COPIED FROM https://github.com/amrfarid140/firebase_auth_oauth/blob/main/firebase_auth_oauth/example/lib/main.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> performLogin(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
    } on PlatformException catch (error) {
      /**
       * The plugin has the following error codes:
       * 1. FirebaseAuthError: FirebaseAuth related error
       * 2. PlatformError: An platform related error
       * 3. PluginError: An error from this plugin
       */
      debugPrint("${error.code}: ${error.message}");
    }
  }

  Future<void> performLink(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth()
          .linkExistingUserWithCredentials(provider, scopes, parameters);
    } on PlatformException catch (error) {
      /**
       * The plugin has the following error codes:
       * 1. FirebaseAuthError: FirebaseAuth related error
       * 2. PlatformError: An platform related error
       * 3. PluginError: An error from this plugin
       */
      debugPrint("${error.code}: ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Microsoft Login Test'),
          ),
          body: StreamBuilder(
              initialData: null,
              stream: FirebaseAuth.instance.userChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                          snapshot.data == null ? "Logged out" : snapshot.data.toString()),
                    ),
                    if (snapshot.data == null ||
                        snapshot.data?.isAnonymous == true) ...[
                      ElevatedButton(
                        onPressed: () async {
                          await performLogin(
                              "microsoft.com", ["email"], {"locale": "en"});
                        },
                        child: Text("Sign in with Microsoft"),
                      ),
                    ],
                    if (snapshot.data != null) ...[
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text("Logout"),
                      )
                    ]
                  ],
                );
              })),
    );
  }
}

/// IMPORTED FOR TESTING PURPOSES ONLY
/// I TAKE NO CREDIT FOR THE CREATION OF THIS FILE
/// COPIED FROM https://github.com/amrfarid140/firebase_auth_oauth/blob/main/firebase_auth_oauth/example/lib/main.dart