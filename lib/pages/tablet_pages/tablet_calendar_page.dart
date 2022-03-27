/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
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

// TabletCalendarPage interfaces with the lecturers calendars and allows
// the user to book meetings
class TabletCalendarPage extends StatefulWidget {
  // Constructor
  const TabletCalendarPage({
    Key? key,
    this.userdata,
    this.lecturerData,
  }) : super(key: key);

  // User data
  final User? userdata;

  // DocumentSnapshot to retrieve the lecturer information
  final DocumentSnapshot<Object?>? lecturerData;

  // Create state function
  @override
  State<TabletCalendarPage> createState() => _TabletCalendarPageState();
}

// State class all StatefulWidgets use
class _TabletCalendarPageState extends State<TabletCalendarPage> {
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

  // Form variables
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Date info
  final DateFormat format = DateFormat("dd-MM-yyyy");
  String _date = "";
  DateTime _meetingStart = DateTime.now();

  // Time info
  String _time = "";
  TimeOfDay _meetingTime = TimeOfDay.now();

  // Controller to retrieve the text from the text fields
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _personEmail = TextEditingController();

  _TabletCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
    _date = format.format(DateTime.now());
    _time = TimeOfDay.now().hour.toString().padLeft(2, '0') +
        ":" +
        TimeOfDay.now().minute.toString().padLeft(2, '0');
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
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _displayPageInfo());
                    })
              ],
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

  // Displays the page info
  Widget _displayPageInfo() {
    return const SimpleDialog(
      title: Center(child: Text('Page Info')),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "On this page you can see when the lecturer has events scheduled\n"
                "You can book a meeting if it isn't to close to any of these events\n"
                "The lecturer will contact you regarding the specifics of you meeting")),
      ],
    );
  }

  // Attempts to create an appointment
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

    // Make sure new event doesn't overlap with existing ones
    for (Event event in _events) {
      // Check if dates match
      if (start.year == event.start!.year &&
          start.month == event.start!.month &&
          start.day == event.start!.day) {
        // Skip checking all day events
        bool? allDay = event.allDay;
        if (allDay != null) {
          if (allDay) {
            continue;
            // Check if start falls within another event
          } else if ((start.hour == event.start!.hour &&
                  start.minute >= event.start!.minute) ||
              (start.hour == event.end!.hour &&
                  start.minute < event.end!.minute)) {
            showDialog(
                context: context,
                builder: (BuildContext context) => const SimpleDialog(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "The time you chose isn't available, please refer\n"
                            "to the calendar to choose an available time",
                            textScaleFactor: 2.0,
                          ),
                        ),
                      ],
                    ));
            return;
            // Check if end falls within another event
          } else if ((end.hour == event.start!.hour &&
                  end.minute > event.start!.minute) ||
              (end.hour == event.end!.hour &&
                  end.minute <= event.end!.minute)) {
            showDialog(
                context: context,
                builder: (BuildContext context) => const SimpleDialog(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "The time you chose is to close to another event,\n "
                            "please refer to the calendar to choose an available time",
                            textScaleFactor: 2.0,
                          ),
                        ),
                      ],
                    ));
            return;
          }
        }
      }
    }

    Event event = Event(_deviceCalendar.id,
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
                  Center(
                      child: Text(
                    "Meeting created successfully!",
                    textScaleFactor: 2.0,
                  )),
                ],
              )).then(
          // Forces a page reload to show that the event has been added
          // Does layer another calendar page on top, but should be fine
          (value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => widget)));
    } else {
      print('Error creating event');
    }
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
        } else if (cal.name == widget.userdata!.email) {
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
