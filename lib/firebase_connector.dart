/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/11/2021

import 'package:capstone_project/widgets/message_widget.dart';
import 'package:capstone_project/models/lecturer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class FirebaseConnector extends ChangeNotifier {

  FirebaseConnector() {init();}

  Future<void> init() async {
    // Initialises the Firebase app
    await Firebase.initializeApp();
    notifyListeners();
  }

  static void uploadData(Lecturer lecturer){
    FirebaseFirestore.instance.collection('lecturer').doc(lecturer.email).set(<String, dynamic>{
      'title': lecturer.title,
      'name': lecturer.name,
      'email': lecturer.email,
      'picture link': lecturer.pictureLink,
      'office hours': lecturer.officeHours,
      'office number': lecturer.officeNumber,
      'busy': lecturer.busy,
      'out of office': lecturer.outOfOffice,
    });
  }

  static void sendMessage(String lecturerEmail, Message message){
    FirebaseFirestore.instance.collection('lecturer').doc(lecturerEmail)
        .collection('messages').add(<String, dynamic>{
          'name': message.sender,
          'text': message.text,
          'time': Timestamp.now(),
    });
  }
}