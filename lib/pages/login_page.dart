/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// imports
import 'dart:async';

import 'package:capstone_project/pages/tablet_main.dart';
import 'package:capstone_project/pages/phone_main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_account_page.dart';

// LoginPage is the first page seen when opening the app
class LoginPage extends StatefulWidget {
  // Constructor
  const LoginPage({Key? key}) : super(key: key);

  // Create state function
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

// State class all StatefulWidgets use
class _LoginPageState extends State<LoginPage> {
  // Used to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Used to get the values of the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // User credentials that will need to be used later
  late User user;
  AlertDialog _loginAlert = const AlertDialog();

  // Initialise function called when the state is created
  @override
  void initState() {
    super.initState();
    // Run this after the build finishes to log in if state is still saved
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Check if logged in
      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser!;
        _logInSuccess(context);
      }
    });
  }

  // Main build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: MediaQuery.of(context).size.shortestSide / 5,
                  backgroundImage:
                      const AssetImage('media/images/DoorSine_V1.png')),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
              Text(
                'DoorSine',
                style: Theme.of(context).textTheme.headline4,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(hintText: 'Password'),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('Log in'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _logIn();
                              // Await for logIn to finish before trying to show dialog
                              if (_loginAlert.title != null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _loginAlert);
                              } else {
                                // Login successful
                                _logInSuccess(context);
                              }
                            }
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0)),
                        ElevatedButton(
                            child: const Text('Create account'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateAccountPage()));
                            })
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                    ElevatedButton(
                        child: const Text("Login with Microsoft"),
                        onPressed: () async {
                          await _microsoftLogIn();
                          if (user.email == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => _loginAlert);
                          } else {
                            // Login successful
                            _logInSuccess(context);
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialogue pop-up if login was successful
  void _logInSuccess(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                'Choose device',
                style: Theme.of(context).textTheme.headline4,
              ),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneMain(userdata: user),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Phone',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabletMain(userdata: user)),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Tablet',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            ));
  }

  // Checks and validates the users email and password
  Future<void> _logIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      user = userCredential.user!;
      _loginAlert = const AlertDialog();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        _loginAlert = AlertDialog(
          title: const Center(child: Text('Error')),
          content:
              const Text('No user with given email and password combination, '
                  'please try again or create an account'),
          actions: <Widget>[
            Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Close'),
                  child: const Text('OK')),
            )
          ],
        );
      }
    }
  }

  // Logs inn using Microsoft credentials
  Future<void> _microsoftLogIn() async {
    try {
      user = (await FirebaseAuthOAuth()
          .openSignInFlow("microsoft.com", ["email"], {"locale": "en"}))!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        _loginAlert = AlertDialog(
          title: const Center(child: Text('Error')),
          content:
          const Text('No user with given email and password combination, '
              'please try again or create an account'),
          actions: <Widget>[
            Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context, 'Close'),
                  child: const Text('OK')),
            )
          ],
        );
      }
    }
  }
}
