/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 31/10/2021

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

  void uploadData(Lecturer lecturer){
    FirebaseFirestore.instance.collection('lecturer').doc(lecturer.email).set(<String, dynamic>{
      'id': lecturer.id,
      'title': lecturer.title,
      'name': lecturer.name,
      'email': lecturer.email,
      'office hours': lecturer.officeHours,
      'busy': lecturer.busy,
      'out of office': lecturer.outOfOffice,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData(){
    return FirebaseFirestore.instance.collection('lecturer').doc('sStt8bGI80yjeIjagxIS').get();
  }
}