/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/01/2022

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
  String? calendarID;
  List<Calendar> _calendars = [];
  List<Event> _events = [];

  // Form variables
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _appointmentName = TextEditingController();
  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _appointmentStart = TextEditingController();
  final TextEditingController _appointmentEnd = TextEditingController();

  _TabletCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
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
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    firstDayOfWeek: 1,
                    showNavigationArrow: true,
                    showWeekNumber: true,
                    dataSource: _getEventsDataSource(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _appointmentName,
                            decoration: const InputDecoration(
                                hintText: 'Appointment name'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please a name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          child: TextFormField(
                            controller: _appointmentDate,
                            decoration: const InputDecoration(
                                hintText: 'Appointment date'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a date';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          child: TextFormField(
                            controller: _appointmentStart,
                            decoration: const InputDecoration(
                                hintText: 'Appointment start'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a start time';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          child: TextFormField(
                            controller: _appointmentEnd,
                            decoration: const InputDecoration(
                                hintText: 'Appointment end'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an end time';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        ElevatedButton(
                            child: const Text('Create Appointment'),
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _createAppointment();
                              }
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _createAppointment() async {
    // TODO: Set location as the lecturers office
    Location location = Location('Office', [0], [0], [TimeZone.UTC]);

    List<String> dateStrings = _appointmentDate.text.split('.');
    List<int> dateInts = [];
    for (String s in dateStrings){
      dateInts.add(int.parse(s));
    }

    List<String> startTimeStrings = _appointmentStart.text.split(':');
    List<int> startTimeInts = [];
    for(String s in startTimeStrings){
      startTimeInts.add(int.parse(s));
    }

    List<String> endTimeStrings = _appointmentEnd.text.split(':');
    List<int> endTimeInts = [];
    for(String s in endTimeStrings){
      endTimeInts.add(int.parse(s));
    }

    TZDateTime start = TZDateTime(location, dateInts[2], dateInts[1], dateInts[0], startTimeInts[0], startTimeInts[1]);
    TZDateTime end = TZDateTime(location, dateInts[2], dateInts[1], dateInts[0], endTimeInts[0], endTimeInts[1]);
    Event event = Event(_calendars[5].id, title: _appointmentName.text, start: start, end: end);
    print(event.end);
    var eventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if(eventResult!.isSuccess && eventResult.data!.isNotEmpty){
      print('Success!');
    } else {
      print(eventResult.data);
    }
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
      // Looking for 'Calendar"=' because that is the default name outlook
      // is imported with to the google calendar
      if (cal.name == 'Calendar') {
        outlookCalendar = cal;
        calendarID = cal.id;
        break;
      }
    }

    if (outlookCalendar != null) {
      // Gets all events this year
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
}
