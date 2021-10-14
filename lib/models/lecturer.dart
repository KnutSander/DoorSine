/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 14/10/2021

//  Create a class to represent the lecturers
class Lecturer {
  // Need to store busy and inOffice as ints because sqlite has no bool type
  int id;
  String title;
  String name;
  bool busy;
  bool inOffice;

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
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'busy': busy ? 0 : 1,
      'inOffice': inOffice ? 0 : 1,
    };
  }

  // Place values from a Map into the lecturer
  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    name = map['name'];
    busy = (map['busy'] == 0) ? false : true;
    inOffice = (map['inOffice'] == 0) ? false : true;
  }

  // toString method to visualize the information about the lecturer nicely
  @override
  String toString() {
    return '$id, $title $name, busy: $busy, inOffice: $inOffice';
  }
}