import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/phone_main.dart';
import 'package:capstone_project/pages/tablet_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 01/11/2021

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.lecturer}) : super(key: key);

  Lecturer lecturer;

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
  late UserCredential userCredential;
  AlertDialog _loginAlert = const AlertDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      // Can removed validators because firebaseAuth does validation as well
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await logIn(_emailController.text,
                                    _passwordController.text);
                                // Await for logIn to finish before trying to show dialog
                                // TODO: Create more sophisticated way of checking login success
                                if (_loginAlert.title != null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _loginAlert);
                                } else {
                                  // Login successful
                                  //TODO: give options to setup tablet or phone side of app
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SimpleDialog(
                                            title: const Text('Choose device'),
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhoneMain(
                                                                lecturer: widget
                                                                    .lecturer),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                },
                                                child: const Text('Phone'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TabletHomePage(
                                                                  lecturer: widget
                                                                      .lecturer)),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                },
                                                child: const Text('Tablet'),
                                              )
                                            ],
                                          ));
                                }
                              }
                            },
                            child: const Text('Log in')),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                //TODO: Open create new user page
                              },
                              child: const Text('Create account')),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Checks and validates the users email and password
  Future<void> logIn(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _loginAlert = const AlertDialog();
    } on FirebaseAuthException catch (e) {
      print(e.code);
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

  void createNewUser() async {}
}
