/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/message_page.dart';

import 'package:flutter/material.dart';

// PhoneMessagePage uses MessagePage to send messages to the other side
// of the app
class PhoneMessagePage extends StatefulWidget{
  // Constructor
  const PhoneMessagePage({Key? key, required this.lecturer}) : super(key: key);

  // Lecturer object
  final Lecturer lecturer;

  // Create state function
  @override
  State<PhoneMessagePage> createState() => _PhoneMessagePageState();
}

// State class all StatefulWidgets use
class _PhoneMessagePageState extends State<PhoneMessagePage>{
  // Main build function
  @override
  Widget build(BuildContext context) {
    return MessagePage(lecturerEmail: widget.lecturer.email, sender: widget.lecturer.title + " " + widget.lecturer.name);
  }
}