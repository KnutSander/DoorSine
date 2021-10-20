/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'package:flutter/material.dart';

class PhoneHomePage extends StatefulWidget{
  const PhoneHomePage({Key? key}) : super(key: key);

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage>{

  bool _busy = false;
  bool _inOffice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                    child: Text(
                        'Available',
                        textAlign: TextAlign.right,
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Switch(
                        value: _busy,
                        onChanged: (bool value) {
                          setState((){
                            _busy = value;
                          });
                        },
                    ),
                  ),
                ),
                const Expanded(child: Text('Busy'))
              ],
            ),
            Row(
              children: <Widget>[
                const Expanded(
                    child: Text(
                        'In Office',
                        textAlign: TextAlign.right,
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: _inOffice,
                      onChanged: (bool value) {
                        setState((){
                          _inOffice = value;
                        });
                      },
                    ),
                  ),
                ),
                const Expanded(child: Text('Out of Office'))
              ],
            ),
          ],
        ),
      );
  }

}