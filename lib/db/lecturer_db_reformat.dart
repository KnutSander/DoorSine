import 'dart:async';

import 'package:capstone_project/models/lecturer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class LecturerDB {
  late List<Lecturer> lecturers;
  late Database database;

  void init() async {
    // Avoid errors caused by flutter upgrade by calling this
    WidgetsFlutterBinding.ensureInitialized();

    // create the reference the database is stored in and open the database
    database = await openDatabase(
      // The first value required is the path to the database
      // The join function from path makes sure that the path
      // is constructed correctly on each platform
      join(await getDatabasesPath(), 'lecturer_database.db'),

      // When the database is first created, create the table that stores lecturers
      onCreate: (db, version) {
        // Run the create table function on the database
        return db.execute(
            'CREATE TABLE lecturers(id INTEGER PRIMARY KEY, title TEXT,'
            'name TEXT, busy INTEGER, inOffice INTEGER)');
      },

      // Set the version for some reason
      version: 1,
    );

    // Function to insert lecturers into the database
    Future<void> insertLecturer(Lecturer lecturer) async {
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

    //await insertLecturer(shoaib);

    Future<List<Lecturer>> getLecturers() async {
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

    lecturers = await getLecturers();
    print(lecturers);
  }
}
