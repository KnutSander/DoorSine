/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2022

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:device_calendar/device_calendar.dart';

import 'package:timezone/src/date_time.dart';
import 'package:timezone/standalone.dart';

import 'package:capstone_project/widgets/calendar_data_source.dart';

class TabletCalendarPage extends StatefulWidget {
  const TabletCalendarPage({Key? key}) : super(key: key);

  @override
  State<TabletCalendarPage> createState() => _TabletCalendarPageState();
}

class _TabletCalendarPageState extends State<TabletCalendarPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  List<Event> _events = [];

  _TabletCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  void _getCalendars() async {
    try {
      var permGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permGranted.isSuccess &&
          (permGranted.data == null || permGranted.data == false)) {
        permGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permGranted.isSuccess ||
            permGranted.data == null ||
            permGranted.data == false) {
          return;
        }
      }

      final calResults = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calResults.data as List<Calendar>;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<UnmodifiableListView<Event>?> _getEvents() async {
    if (_calendars.isEmpty) {
      _getCalendars();
    }

    var outlookCalendar;
    for (Calendar cal in _calendars) {
      if (cal.name == 'Calendar') {
        outlookCalendar = cal;
        break;
      }
    }

    if (outlookCalendar != null) {
      // Should get all events this year
      var events = await _deviceCalendarPlugin.retrieveEvents(
          outlookCalendar.id,
          RetrieveEventsParams(
              startDate: DateTime(DateTime.now().year),
              endDate: DateTime(DateTime.now().year + 1)));

      return events.data;
    } else {
      print('No Outlook Calendar');
    }
  }

  CDS _getEventsDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for (Event event in _events) {
      appointments.add(Appointment(
          color: const Color.fromRGBO(205, 61, 50, 1),
          subject: event.title.toString(),
          startTime: DateTime(event.start!.year, event.start!.month,
              event.start!.day, event.start!.hour, event.start!.minute),
          endTime: DateTime(event.end!.year, event.end!.month, event.end!.day,
              event.end!.hour, event.end!.minute)));
    }

    return CDS(appointments);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _getEvents(),
        builder: (BuildContext context,
            AsyncSnapshot<UnmodifiableListView<Event>?> snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text('Something went wrong')));
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  value: null,
                ),
              ),
            );
          }

          UnmodifiableListView<Event>? eventList = snapshot.data;
          if (eventList != null) {
            for (Event event in eventList) {
              if (!_events.contains(event)) {
                _events.add(event);
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Calendar'),
            ),
            body: SfCalendar(
              view: CalendarView.week,
              firstDayOfWeek: 1,
              showNavigationArrow: true,
              showWeekNumber: true,
              dataSource: _getEventsDataSource(),
            ),
          );
        });
  }
}