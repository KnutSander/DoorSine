/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:device_calendar/device_calendar.dart';

import 'package:capstone_project/widgets/calendar_data_source.dart';

// PhoneCalendarPage class
class PhoneCalendarPage extends StatefulWidget {
  // Constructor
  PhoneCalendarPage({Key? key, required this.lecturerEmail}) : super(key: key);

  // Lecturer email
  String lecturerEmail;

  // Create state function
  @override
  State<PhoneCalendarPage> createState() => _PhoneCalendarPageState();
}

// State class all StatefulWidgets use
class _PhoneCalendarPageState extends State<PhoneCalendarPage> {
  // Calendar plugin to interface with the device calendar
  late DeviceCalendarPlugin _deviceCalendarPlugin;

  // The normal device calendar and outlook calendar
  late Calendar _deviceCalendar, _outlookCalendar;

  // ID of the device calendar
  String? calendarID;

  // List of all calendars
  List<Calendar> _calendars = [];

  // List of all events
  List<Event> _events = [];

  _PhoneCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  // Main build function
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.runtimeType.toString() == 'LateError') {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    value: null,
                  ),
                ),
              );
            } else {
              return Scaffold(
                  body: Center(child: Text(snapshot.error.toString())));
            }
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

          List<Event>? eventList = snapshot.data;
          if (eventList != null && _events.isEmpty) {
            for (Event event in eventList) {
              _events.add(event);
            }
          }

          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    firstDayOfWeek: 1,
                    showNavigationArrow: true,
                    showWeekNumber: true,
                    dataSource: _getEventsDataSource(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // Get the calendars from the device
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

      // Assign outlook and device calendar
      for (Calendar cal in _calendars) {
        if (cal.name == 'Calendar') {
          _outlookCalendar = cal;
        } else if (cal.name == widget.lecturerEmail) {
          _deviceCalendar = cal;
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // Get the events from the calendar
  Future<List<Event>> _getEvents() async {
    if (_calendars.isEmpty) {
      _getCalendars();
    }

    List<Event> combinedEvents = [];

    if (_outlookCalendar != null) {
      var events = await _deviceCalendarPlugin.retrieveEvents(
          _outlookCalendar.id,
          RetrieveEventsParams(
              startDate: DateTime(DateTime.now().year),
              endDate: DateTime(DateTime.now().year + 1)));

      UnmodifiableListView<Event>? list = events.data;

      if (list!.isNotEmpty) {
        for (Event e in list) {
          combinedEvents.add(e);
        }
      }
    }

    if (_deviceCalendar != null) {
      var events = await _deviceCalendarPlugin.retrieveEvents(
          _deviceCalendar.id,
          RetrieveEventsParams(
              startDate: DateTime(DateTime.now().year),
              endDate: DateTime(DateTime.now().year + 1)));

      UnmodifiableListView<Event>? list = events.data;

      if (list!.isNotEmpty) {
        for (Event e in list) {
          combinedEvents.add(e);
        }
      }
    }
    return combinedEvents;
  }

  // Create the calendar datasource objects
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
}
