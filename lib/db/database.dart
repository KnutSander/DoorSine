import 'package:capstone_project/db/lecturer_db_original.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider{
  // Constructor
  DatabaseProvider._();

  // Reference to a DatabaseProvider
  static final DatabaseProvider dbp = DatabaseProvider._();

  // The actual database
  static late Database _database;

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }
  
  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'lecturer_database.db'),
      onCreate: (db, version) async {
        // Run the create table function on the database
        await db.execute('''
                CREATE TABLE lecturers (
                id INTEGER PRIMARY KEY, 
                title TEXT,
                name TEXT, 
                busy INTEGER, 
                inOffice INTEGER)
        ''');
      },
      version: 1
    );
  }

  newLecturer(Lecturer newLecturer) async{
    final db = await database;

    var response = await db.rawInsert('''
      INSERT INTO lecturers (
        id, title, name, busy, inOffice
      ) VALUES (?, ?, ?, ?, ?)
    ''', [newLecturer.id, newLecturer.title, newLecturer.name,
        newLecturer.busy, newLecturer.inOffice]
    );

    return response;
  }
  
  Future<dynamic> getLecturer() async{
    final db = await database;
    
    var response = await db.query("lecturers");
    if(response.isEmpty) {
      return null;
    } else {
      var responseMap = response[0];
      return responseMap.isNotEmpty ? responseMap : null;
    }
  }
}