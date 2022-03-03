/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'package:capstone_project/widgets/app_theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({Key? key}) : super(key: key);

  @override
  State<TestingPage> createState() => _TestingPageState();

}

class _TestingPageState extends State<TestingPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Testing App",
      theme: AppTheme.appTheme,
      home: pageContent(),
    );
  }

  Widget pageContent(){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing Page"),
      ),
      body: Column(
        children: <Widget>[
          Text("headline1", style: Theme.of(context).textTheme.headline1,),
          Text("headline2", style: Theme.of(context).textTheme.headline2,),
          Text("headline3", style: Theme.of(context).textTheme.headline3,),
          Text("headline4", style: Theme.of(context).textTheme.headline4,),
          Text("headline5", style: Theme.of(context).textTheme.headline5,),
          Text("headline6", style: Theme.of(context).textTheme.headline6,),
          Text("bodyText1", style: Theme.of(context).textTheme.bodyText1,),
          Text("bodyText2", style: Theme.of(context).textTheme.bodyText2,),
          Text("subtitle1", style: Theme.of(context).textTheme.subtitle1,),
          Text("subtitle2", style: Theme.of(context).textTheme.subtitle2,),
          Text("overline", style: Theme.of(context).textTheme.overline,),
          Text("button", style: Theme.of(context).textTheme.button,),
          Text("caption", style: Theme.of(context).textTheme.caption,),
        ]
      ),
    );
  }

}