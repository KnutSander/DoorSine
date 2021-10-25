/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 25/10/2021

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

  Future<DocumentReference> uploadData(Lecturer lecturer){
    return FirebaseFirestore.instance.collection('lecturer').add(<String, dynamic>{
      'id': lecturer.id,
      'title': lecturer.title,
      'name': lecturer.name,
      'email': lecturer.email,
      'office hours': lecturer.officeHours,
      'busy': lecturer.busy,
      'in office': lecturer.inOffice,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData(){
    return FirebaseFirestore.instance.collection('lecturer').doc('sStt8bGI80yjeIjagxIS').get();
  }
}