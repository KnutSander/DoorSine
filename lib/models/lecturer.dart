/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 14/10/2021

//  Create a class to represent the lecturers
class Lecturer {
  // Need to store busy and inOffice as ints because sqlite has no bool type
  int id;
  String title;
  String name;
  String email;
  String pictureLink;
  String officeHours;
  bool busy;
  bool inOffice;


  // Constructor
  Lecturer({
    required this.id,
    required this.title,
    required this.name,
    required this.email,
    required this.pictureLink,
    required this.officeHours,
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

List<Lecturer> getLecturers(){
  var shoaib = Lecturer(
    id: 0,
    title: 'Dr.',
    name: 'Jameel, Shoaib',
    email: 'shoaib.jameel@essex.ac.uk',
    pictureLink: 'http://www1.essex.ac.uk/people-images/JAMEE22406.jpg',
    officeHours: '12:00-13:00, Tuesdays',
    busy: false,
    inOffice: true,
  );

  var vishu = Lecturer(
    id: 1,
    title: 'Dr.',
    name: 'Mohan, Vishwanathan',
    email: 'vm16090@essex.ac.uk',
    pictureLink: 'http://www1.essex.ac.uk/people-images/MOHAN05903.jpg',
    officeHours: '10-13, Monday-Friday',
    busy: true,
    inOffice: true,
  );

  var anthony = Lecturer(
    id: 2,
    title: 'Prof.',
    name: 'Vickers, Anthony',
    email: 'vicka@essex.ac.uk',
    pictureLink: 'http://www1.essex.ac.uk/people-images/VICKE53909.jpg',
    officeHours: '14:00-15:00, Thursdays',
    busy: false,
    inOffice: false,
  );

  var john = Lecturer(
    id: 3,
    title: 'Prof.',
    name: 'Gan, John',
    email: 'jqgan@essex.ac.uk',
    pictureLink: 'http://www1.essex.ac.uk/people-images/GANJO00207.jpg',
    officeHours: '11:00-12:00, Thursdays',
    busy: true,
    inOffice: false,
  );

  return [shoaib, vishu, anthony, john];
}