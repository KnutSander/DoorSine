/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/01/2022

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:device_calendar/device_calendar.dart';

import 'package:timezone/src/date_time.dart';
import 'package:timezone/standalone.dart';

import 'package:capstone_project/widgets/calendar_data_source.dart';

class TabletCalendarPage extends StatefulWidget {
  const TabletCalendarPage({
    Key? key,
    this.userdata,
    this.lecturerData,
  }) : super(key: key);

  final User? userdata;
  final DocumentSnapshot<Object?>? lecturerData;

  @override
  State<TabletCalendarPage> createState() => _TabletCalendarPageState();
}

class _TabletCalendarPageState extends State<TabletCalendarPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  List<Event> _events = [];

  // Form variables
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Date info
  final DateFormat format = DateFormat("dd-MM-yyyy");
  String _date = "";
  DateTime _meetingStart = DateTime.now();

  // Time info
  String _time = "";
  TimeOfDay _meetingTime = TimeOfDay.now();

  final TextEditingController _personName = TextEditingController();
  final TextEditingController _personEmail = TextEditingController();

  _TabletCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    _date = format.format(DateTime.now());
    _time = TimeOfDay.now().hour.toString().padLeft(2, '0') +
        ":" +
        TimeOfDay.now().minute.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body:
                    Center(child: Text("Error: " + snapshot.error.toString())));
          }

          if (snapshot.data == [] || snapshot.data == null) {
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
                          flex: 2,
                          child: TextFormField(
                            controller: _personName,
                            decoration:
                                const InputDecoration(hintText: 'Your name'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _personEmail,
                            decoration:
                                const InputDecoration(hintText: 'Your Email'),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                            child: OutlinedButton(
                                child: Text(_date),
                                onPressed: () async {
                                  var meetingDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year,
                                        DateTime.december, 31),
                                  );
                                  setState(() {
                                    if (meetingDate != null) {
                                      _date = format.format(meetingDate);
                                      _meetingStart = meetingDate;
                                    }
                                  });
                                })),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Expanded(
                            child: OutlinedButton(
                          child: Text(_time),
                          onPressed: () async {
                            var meetingTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            setState(() {
                              if (meetingTime != null) {
                                _time = meetingTime.hour
                                        .toString()
                                        .padLeft(2, '0') +
                                    ":" +
                                    meetingTime.minute
                                        .toString()
                                        .padLeft(2, '0');
                                _meetingTime = meetingTime;
                              }
                            });
                          },
                        )),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        ElevatedButton(
                            child: const Text('Create Appointment'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
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
    Location location = Location(
        widget.lecturerData!.get('office number').toString(),
        [0],
        [0],
        [TimeZone.UTC]);

    TZDateTime start = TZDateTime(
        location,
        _meetingStart.year,
        _meetingStart.month,
        _meetingStart.day,
        _meetingTime.hour,
        _meetingTime.minute);

    TZDateTime end = TZDateTime(
        location,
        _meetingStart.year,
        _meetingStart.month,
        _meetingStart.day,
        _meetingTime.hour + 1,
        _meetingTime.minute);

    Event event = Event(_calendars[5].id,
        title: "Meeting",
        start: start,
        end: end,
        description: _personName.text +
            " with email " +
            _personEmail.text +
            " wants a meeting at the given time and date");

    var eventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);

    if (eventResult!.isSuccess && eventResult.data!.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const SimpleDialog(
                children: <Widget>[
                  Text("Meeting created successfully!"),
                ],
              )).then(
          // Forces a page reload to show that the event has been added
          // Does layer another calendar page on top, but should be fine
          (value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => widget)));
    } else {
      print('Error creating event');
    }

    // TODO: Reload events after the appointment is created
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

  Future<List<Event>> _getEvents() async {
    if (_calendars.isEmpty) {
      _getCalendars();
    }

    var outlookCalendar, personalCalendar;
    for (Calendar cal in _calendars) {
      // Looking for 'Calendar"=' because that is the default name outlook
      // is imported with to the google calendar
      if (cal.name == 'Calendar') {
        outlookCalendar = cal;
      } else if (cal.name == widget.userdata!.email) {
        personalCalendar = cal;
      }
    }

    List<Event> combinedEvents = [];

    if (outlookCalendar != null) {
      var events = await _deviceCalendarPlugin.retrieveEvents(
          outlookCalendar.id,
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

    if (personalCalendar != null) {
      var events = await _deviceCalendarPlugin.retrieveEvents(
          personalCalendar.id,
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
