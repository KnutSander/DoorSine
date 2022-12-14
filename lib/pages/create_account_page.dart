/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:capstone_project/widgets/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// CreateAccountPage is where new users can create an account
class CreateAccountPage extends StatefulWidget {
  // Constructor
  const CreateAccountPage({Key? key}) : super(key: key);

  // Create state function
  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

// State class all StatefulWidgets use
class _CreateAccountState extends State<CreateAccountPage> {
  // Key to make sure the form has been completed correctly
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers to retrieve the text from the form text fields
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _officeNumber = TextEditingController();
  final TextEditingController _officeHours = TextEditingController();

  // Boolean to check if creation was successful
  bool creationSuccessful = false;

  // Build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(hintText: 'Password'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordConfirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Confirm Password'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (value != _password.text) {
                                return 'Please provide the same password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _title,
                            decoration:
                                const InputDecoration(hintText: 'Title'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your title';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(hintText: 'Name'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _officeNumber,
                            decoration: const InputDecoration(
                                hintText: 'Office Number'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your office number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _officeHours,
                            decoration:
                                const InputDecoration(hintText: 'Office Hours'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your office hours';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: const Text("Create Account"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await createAccount();
                          if (creationSuccessful) {
                            // Close creation screen and return to
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const SimpleDialog(
                                title: Text("Creation Successful"),
                                children: <Widget>[
                                  Center(child: Text('Please log in')),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                    ElevatedButton(
                        child: const Text('Create Account with Microsoft'),
                        onPressed: () async {
                          await createAccountWithMicrosoft();
                          if (creationSuccessful) {
                            // Close creation screen and return to
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const SimpleDialog(
                                title: Text("Creation Successful"),
                                children: <Widget>[
                                  Center(child: Text('Please log in')),
                                ],
                              ),
                            );
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

  // Attempts to create an account given the information provided in the form
  Future<void> createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Lecturer newLecturer = Lecturer(
          title: _title.text,
          name: _name.text,
          email: _email.text,
          pictureLink: '',
          officeHours: _officeHours.text,
          officeNumber: _officeNumber.text,
          busy: false,
          outOfOffice: false);
      FirebaseConnector.uploadData(newLecturer);
      creationSuccessful = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                  title: Center(
                    child: Text('Error'),
                  ),
                  content: Text('Password too weak'),
                ));
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                  title: Center(
                    child: Text('Error'),
                  ),
                  content: Text('Email is already in use'),
                ));
      }
    }
  }

  // Attempts to create an account using a Microsoft login
  Future<void> createAccountWithMicrosoft() async {
    User? user = await FirebaseAuthOAuth()
        .openSignInFlow("microsoft.com", ["email"], {"locale": "en"});

    // Try getting the user document
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('lecturer')
        .doc(user?.email)
        .get();

    // If user exists, display error message
    if (data.exists) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
                title: Center(
                  child: Text('Error'),
                ),
                content: Text('Microsoft account already in use'),
              ));
    } else {
      if (user != null) {
        Lecturer newLecturer = Lecturer(
            title: '',
            name: user.displayName.toString(),
            email: user.email.toString(),
            pictureLink: '',
            officeHours: '',
            officeNumber: '',
            busy: false,
            outOfOffice: false);
        FirebaseConnector.uploadData(newLecturer);
        creationSuccessful = true;
      }
    }
  }
}
