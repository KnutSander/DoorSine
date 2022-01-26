/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/models/lecturer.dart';
import 'package:capstone_project/pages/message_page.dart';

import 'package:flutter/material.dart';

class PhoneMessagePage extends StatefulWidget{
  final Lecturer lecturer;
  const PhoneMessagePage({Key? key, required this.lecturer}) : super(key: key);

  @override
  State<PhoneMessagePage> createState() => _PhoneMessagePageState();
}

class _PhoneMessagePageState extends State<PhoneMessagePage>{
  @override
  Widget build(BuildContext context) {
    return MessagePage(lecturerEmail: widget.lecturer.email, sender: widget.lecturer.title + " " + widget.lecturer.name);
  }


}