import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

void main() async {

  // Avoid errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();

  // open database and store a reference
  final database = openDatabase(
    // Set the database path
    join(await getDatabasesPath(), 'lecturer_database.db'),

    // When the database is created, create the table that stores lecturers
    onCreate: (db, version){
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

    // Insert the given lecturer
    await db.insert(
      'lecturers',
      lecturer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Create a lecturer
  var shoaib = Lecturer(
    id: 0,
    title: 'Dr.',
    name: 'Jameel, Shoaib',
    busy: 0,
    inOffice: 1,
  );

  await insertLecturer(shoaib);

  Future<List<Lecturer>> lecturers() async{
    // Database reference
    final db = await database;

    // Query table for all data
    final List<Map<String, dynamic>> maps = await db.query('lecturers');

    // Convert from  List<Map<String, dynamic>> into List<Lecturers>
    return List.generate(maps.length, (index) {
      return Lecturer(
          id: maps[index]['id'],
          title: maps[index]['title'],
          name: maps[index]['name'],
          busy: maps[index]['busy'],
          inOffice: maps[index]['inOffice'],
      );
    });
  }

  print(await lecturers());
}

//  Create a class to represent the lecturers
class Lecturer{
  // Need to store busy and inOffice as ints because sqlite has no bool type
  final int id;
  final String title;
  final String name;
  final int busy;
  final int inOffice;

  Lecturer({
    required this.id,
    required this.title,
    required this.name,
    required this.busy,
    required this.inOffice,
  });

  // Function that converts the info about the lecturer into a Map
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'name' : name,
      'busy' : busy,
      'inOffice' : inOffice,
    };
  }

  // toString method to visualize the information nicely
  @override
  String toString(){
    return 'Dog(id: $id, title: $title, name: $name, busy: $busy, inOffice: $inOffice)';
  }
}