/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'package:flutter/material.dart';

class PhoneSettingsPage extends StatefulWidget{
  const PhoneSettingsPage({Key? key}) : super(key: key);

  @override
  State<PhoneSettingsPage> createState() => _PhoneSettingsPageState();
}

class _PhoneSettingsPageState extends State<PhoneSettingsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Settings will go here"),
    );
  }

}