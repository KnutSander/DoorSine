/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 16/02/2022

import 'package:capstone_project/pages/tablet_main.dart';
import 'package:capstone_project/pages/phone_main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Used to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Initialise firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Used to get the values of the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // User credentials that will need to be used later
  late User user;
  AlertDialog _loginAlert = const AlertDialog();

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
                      const AssetImage('media/images/DoorSine_V1.png')
              ),
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
                      width: MediaQuery.of(context).size.width/1.5,
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
                      width: MediaQuery.of(context).size.width/1.5,
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
                              await logIn();
                              // Await for logIn to finish before trying to show dialog
                              if (user.email == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _loginAlert);
                              } else {
                                // Login successful
                                logInSuccess(context);
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
                                          CreateAccountPage()));
                            })
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                    ElevatedButton(
                        child: const Text("Login with Microsoft"),
                        onPressed: () async {
                          await logInWithMicrosoft();
                          if (user.email == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => _loginAlert);
                          } else {
                            // Login successful
                            logInSuccess(context);
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

  void logInSuccess(BuildContext context) {
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
                            builder: (context) =>
                                TabletMain(userdata: user)),
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
  Future<void> logIn() async {
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
          title: const Text('Error'),
          content:
              const Text('No user with given email and password combination, '
                  'please try again or create an account'),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context, 'Close'),
                child: const Text('OK'))
          ],
        );
      }
    }
  }

  Future<void> logInWithMicrosoft() async {
    try {
      user = (await FirebaseAuthOAuth()
          .openSignInFlow("microsoft.com", ["email"], {"locale": "en"}))!;
    } catch (e) {
      // _loginAlert = AlertDialog(
      //   title: const Text('Error'),
      //   content:
      //   const Text('No user with given email and password combination, '
      //       'please try again or create an account'),
      //   actions: <Widget>[
      //     TextButton(
      //         onPressed: () => Navigator.pop(context, 'Close'),
      //         child: const Text('OK'))
      //   ],
      // );
      print(e);
    }
  }
}
