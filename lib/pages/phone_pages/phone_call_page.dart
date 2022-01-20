/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 19/01/2021

import 'package:flutter/material.dart';

class PhoneCallPage extends StatefulWidget{
  const PhoneCallPage({Key? key}) : super(key: key);

  @override
  State<PhoneCallPage> createState() => _PhoneCallPageState();
}

class _PhoneCallPageState extends State<PhoneCallPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Calling capabilities will go here"),
    );
  }

}