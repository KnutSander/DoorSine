/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/10/2021

import 'package:capstone_project/models/lecturer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({Key? key, required this.lecturer}) : super(key: key);

  final Lecturer lecturer;

  @override
  State<TestingPage> createState() => _TestingPageState();

}

class _TestingPageState extends State<TestingPage> {

  @override
  Widget build(BuildContext context) {
    CollectionReference lecturers = FirebaseFirestore.instance.collection('lecturer');

    return FutureBuilder<QuerySnapshot>(
      future: lecturers.where('id', isEqualTo: widget.lecturer.id).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(snapshot.hasError){
          return Text('Shits fucked!');
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('Loading');
        }

        DocumentSnapshot documentSnapshot = snapshot.data!.docs.first;

        return Text(documentSnapshot.get('id').toString());
      },
    );
  }

}