/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TabletCalendarPage extends StatefulWidget{
  const TabletCalendarPage({Key? key}) : super(key: key);

  @override
  State<TabletCalendarPage> createState() => _TabletCalendarPageState();
}

class _TabletCalendarPageState extends State<TabletCalendarPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(
          view: CalendarView.week,
          showNavigationArrow: true,
          showWeekNumber: true,
        ),
      ),
    );
  }

}