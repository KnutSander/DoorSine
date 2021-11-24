/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 17/11/2021

import 'package:capstone_project/Widgets/message_widget.dart';
import 'package:capstone_project/widgets/message_page.dart';
import 'package:flutter/material.dart';

class PhoneMessagePage extends StatefulWidget{
  const PhoneMessagePage({Key? key}) : super(key: key);

  @override
  State<PhoneMessagePage> createState() => _PhoneMessagePageState();
}

class _PhoneMessagePageState extends State<PhoneMessagePage>{
  @override
  Widget build(BuildContext context) {
    return const MessagePage();
  }


}