/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'package:flutter/material.dart';

class PhoneMessagePage extends StatefulWidget{
  const PhoneMessagePage({Key? key}) : super(key: key);

  @override
  State<PhoneMessagePage> createState() => _PhoneMessagePageState();
}

class _PhoneMessagePageState extends State<PhoneMessagePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Messages will go here"),
    );
  }

}