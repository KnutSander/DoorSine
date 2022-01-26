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

class PhoneCalendarPage extends StatefulWidget {
  const PhoneCalendarPage({Key? key}) : super(key: key);

  @override
  State<PhoneCalendarPage> createState() => _PhoneCalendarPageState();
}

class _PhoneCalendarPageState extends State<PhoneCalendarPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  List<Event> _events = [];

  _PhoneCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getCalendars();
  // }

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

      // Get the data and try adding them to the _events list
      //UnmodifiableListView<Event>? eventList = events.data;
      // if (eventList != null) {
      //   for (Event event in eventList) {
      //     if(!_events.contains(event)) {
      //       _events.add(event);
      //     }
      //   }
      // }
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
    // return Scaffold(
    //   body: Container(
    //     child: SfCalendar(
    //       view: CalendarView.week,
    //       firstDayOfWeek: 1,
    //       showNavigationArrow: true,
    //       showWeekNumber: true,
    //       dataSource: _getEventsDataSource(),
    //     ),
    //   ),
    // );

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

class CDS extends CalendarDataSource {
  CDS(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}

// TESTING CODE, FOR REFERENCE
// return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: ListView.builder(
//               itemCount: _calendars.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   key: Key(_calendars[index].isReadOnly == true
//                       ? 'readOnlyCalendar${_readOnlyCals.indexWhere((c) => c.id == _calendars[index].id)}'
//                       : 'writableCalendar${_writableCals.indexWhere((c) => c.id == _calendars[index].id)}'),
//                   onTap: () async {
//                     if(_calendars[index].isReadOnly == false){
//                       // USE calendar.accountType to only place outlook events into the calendar
//                       print(_calendars[index].accountType);
//                       // Creates a new event at the given date and time
//                       // Location location = Location('Somewhere', [0], [0], [TimeZone.UTC]);
//                       // TZDateTime start = TZDateTime(location, 2022, 1, 23, 12, 30);
//                       // TZDateTime end = TZDateTime(location, 2022, 1, 23, 13);
//                       // Event event = Event(_calendars[index].id, title: 'ABBA', start: start, end: end);
//                       // var eventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
//                       // if(eventResult!.isSuccess && eventResult.data!.isNotEmpty){
//                       //   print('Success!');
//                       // } else {
//                       //   print(eventResult.data);
//                       // }
//
//                       // var events = await _deviceCalendarPlugin.retrieveEvents(_calendars[index].id,
//                       //     RetrieveEventsParams(startDate: DateTime.now(), endDate: DateTime(2023)));
//                       // UnmodifiableListView<Event>? eventList = events.data;
//                       // if(eventList != null){
//                       //   for(Event e in eventList){
//                       //     print(e.title);
//                       //   }
//                       // } else {
//                       //   print("No events to print");
//                       // }
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             _calendars[index].name!,
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                         ),
//                         Container(
//                           width: 15,
//                           height: 15,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Color(_calendars[index].color!)),
//                         ),
//                         SizedBox(width: 10),
//                         Container(
//                           margin: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
//                           padding: const EdgeInsets.all(3.0),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: Colors.blueAccent)),
//                           child: Text('Default'),
//                         ),
//                         Icon(_calendars[index].isReadOnly == true
//                             ? Icons.lock
//                             : Icons.lock_open)
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
