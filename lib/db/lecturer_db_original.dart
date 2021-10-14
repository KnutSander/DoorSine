/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 14/10/2021

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

void main() async {
  // Avoid errors caused by flutter upgrade by calling this
  WidgetsFlutterBinding.ensureInitialized();

  // create the reference the database is stored in and open the database
  final database = openDatabase(

    // The first value required is the path to the database
    // The join function from path makes sure that the path
    // is constructed correctly on each platform
    join(await getDatabasesPath(), 'lecturer_database.db'),

    // When the database is first created, create the table that stores lecturers
    onCreate: (db, version){

      // Run the create table function on the database
      return db.execute(
          'CREATE TABLE lecturers(id INTEGER PRIMARY KEY, title TEXT,'
              'name TEXT, busy INTEGER, inOffice INTEGER)'
      );
    },

    // Set the version for some reason
    version: 1,
  );

  // Function to insert lecturers into the database
  Future<void> insertLecturer(Lecturer lecturer) async{
    // Database reference
    final db = await database;

    // Insert the given lecturer into the database
    // If an object that is already in the database is inserted again,
    // the conflictAlgorithm replaces the entry with the new one
    await db.insert(
      'lecturers',
      lecturer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Create a Lecturer objects
  var shoaib = Lecturer(
    id: 0,
    title: 'Dr.',
    name: 'Jameel, Shoaib',
    busy: false,
    inOffice: true,
  );

  await insertLecturer(shoaib);

  Future<List<Lecturer>> getLecturers() async{
    // Database reference
    final db = await database;

    // Query table for all lecturers
    // Returns a list of maps, where every map contain the info about the lecturer
    final List<Map<String, dynamic>> maps = await db.query('lecturers');

    // Convert from  List<Map<String, dynamic>> into List<Lecturers>
    // Convert back from 0 and 1 to false and true for busy and inOffice
    return List.generate(maps.length, (index) {
      return Lecturer(
          id: maps[index]['id'],
          title: maps[index]['title'],
          name: maps[index]['name'],
          busy: (maps[index]['busy'] == 0) ? false : true,
          inOffice: (maps[index]['inOffice'] == 0) ? false : true,
      );
    });
  }

  print(await getLecturers());
}

//  Create a class to represent the lecturers
class Lecturer{
  // Need to store busy and inOffice as ints because sqlite has no bool type
  final int id;
  final String title;
  final String name;
  final bool busy;
  final bool inOffice;

  // Constructor
  Lecturer({
    required this.id,
    required this.title,
    required this.name,
    required this.busy,
    required this.inOffice,
  });

  // Function that converts the info about the lecturer into a Map
  // The keys must match the name of the columns in the database
  // Covert busy and inOffice to int because SQLite doesn't store bools
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'name' : name,
      'busy' : busy ? 0 : 1,
      'inOffice' : inOffice ? 0 : 1,
    };
  }

  // toString method to visualize the information about the lecturer nicely
  @override
  String toString(){
    return '$id, $title $name, busy: $busy, inOffice: $inOffice';
  }
}