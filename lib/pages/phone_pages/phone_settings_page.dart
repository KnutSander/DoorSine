/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/firebase_connector.dart';
import 'package:capstone_project/models/lecturer.dart';

import 'package:flutter/material.dart';

class PhoneSettingsPage extends StatefulWidget {
  const PhoneSettingsPage({Key? key, required this.lecturer}) : super(key: key);

  final Lecturer lecturer;

  @override
  State<PhoneSettingsPage> createState() => _PhoneSettingsPageState();
}

class _PhoneSettingsPageState extends State<PhoneSettingsPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _officeNumber = TextEditingController();
  final TextEditingController _officeHours = TextEditingController();
  final TextEditingController _pictureLink = TextEditingController();

  // Allow changing of title, name, office hours and number, picture link
  @override
  Widget build(BuildContext context) {
    _title.text = widget.lecturer.title;
    _name.text = widget.lecturer.name;
    _officeNumber.text = widget.lecturer.officeNumber;
    _officeHours.text = widget.lecturer.officeHours;
    _pictureLink.text = widget.lecturer.pictureLink;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(hintText: 'Title.'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your title';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0)),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            hintText: 'Last Name, First Name'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _officeNumber,
                        decoration:
                            const InputDecoration(hintText: 'Office Number'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your office number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0)),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _officeHours,
                        decoration: const InputDecoration(hintText: 'Office Hours'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your office hours';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                TextFormField(
                  controller: _pictureLink,
                  decoration: const InputDecoration(hintText: 'Picture Link'),
                  minLines: 3,
                  maxLines: 6,
                  // TODO: Implement picture link validator somehow
                  // TODO: Implement picture uploading
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your office hours';
                    }
                    return null;
                  },
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                ElevatedButton(
                  child: Text(
                      'Update Info',
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                        color: Colors.white
                    ),
                  ),
                  onPressed: updateInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateInfo(){
    widget.lecturer.title = _title.text;
    widget.lecturer.name = _name.text;
    widget.lecturer.officeNumber = _officeNumber.text;
    widget.lecturer.officeHours = _officeHours.text;
    widget.lecturer.pictureLink = _pictureLink.text;
    FirebaseConnector.uploadData(widget.lecturer);
    setState(() {});
    // TODO: Tell user it was successful
  }
}
