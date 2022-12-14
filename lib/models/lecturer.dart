/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 24/03/2021

//  A class that represents a lecturer and what it stores
class Lecturer {
  String title;
  String name;
  String email;
  String pictureLink;
  String officeHours;
  String officeNumber;
  bool busy;
  bool outOfOffice;

  // Constructor
  Lecturer({
    required this.title,
    required this.name,
    required this.email,
    required this.pictureLink,
    required this.officeHours,
    required this.officeNumber,
    required this.busy,
    required this.outOfOffice,
  });

  // Empty constructor for
  Lecturer.empty()
      : title = '',
        name = '',
        email = '',
        pictureLink = '',
        officeHours = '',
        officeNumber = '',
        busy = false,
        outOfOffice = false;

  // Function that converts the info about the lecturer into a Map
  // The keys must match the name of the columns in the database
  // Covert busy and inOffice to int because SQLite doesn't store booleans
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'name': name,
      'email': email,
      'picture link': pictureLink,
      'office hours': officeHours,
      'office number': officeNumber,
      'busy': busy,
      'out of office': outOfOffice,
    };
  }

  // Place values from a Map into the lecturer
  void fromMap(Map<String, dynamic> map) {
    title = map['title'];
    name = map['name'];
    email = map['email'];
    pictureLink = map['picture link'];
    officeHours = map['office hours'];
    officeNumber = map['office number'];
    busy = map['busy'];
    outOfOffice = map['out of office'];
  }
}
