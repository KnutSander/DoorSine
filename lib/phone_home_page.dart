/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 12/10/2021

import 'package:flutter/material.dart';

class PhoneHomePage extends StatefulWidget{
  const PhoneHomePage({Key? key}) : super(key: key);

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();

}

class _PhoneHomePageState extends State<PhoneHomePage>{

  bool _available = false;
  bool _inOffice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Name'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.room_service),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendar'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body:  Center(
        child: Column(
          children: <Widget>[
            SwitchListTile(
                title: Text(_available
                          ? 'Available'
                          : 'Busy'
                ),
                value: _available,
                onChanged: (bool value) {
                  setState((){
                    _available = value;
                  });
                },
            ),
            SwitchListTile(
              title: Text(_inOffice
                          ? 'In Office'
                          : 'Out of Office'
              ),
              value: _inOffice,
              onChanged: (bool value) {
                setState((){
                  _inOffice = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

}