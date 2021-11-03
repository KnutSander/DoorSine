import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 01/11/2021

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

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
  late AlertDialog _loginAlert;

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
                                // await for logIn to finish before trying to show dialog
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _loginAlert);
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
  // TODO: Make something happen when it's validated
  Future<void> logIn(String email, String password) async {
    late Text title, message, button;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      title = const Text('Success!');
      message = const Text('Login was successful!');
      button = const Text('Yay!');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        title = const Text('Error');
        message =
            const Text('No user with given email and password combination, '
                'please try again or create an account');
        button = const Text('OK');
      }
    }
    _loginAlert = AlertDialog(
      title: title,
      content: message,
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, 'Close'), child: button)
      ],
    );
  }

  void createNewUser() async {}
}
