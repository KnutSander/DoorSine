/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 20/10/2021

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/src/date_time.dart';
import 'package:timezone/standalone.dart';


class PhoneCalendarPage extends StatefulWidget {
  const PhoneCalendarPage({Key? key}) : super(key: key);

  @override
  State<PhoneCalendarPage> createState() => _PhoneCalendarPageState();
}

class _PhoneCalendarPageState extends State<PhoneCalendarPage> {
  late DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars = [];
  List<Calendar> get _writableCals =>
      _calendars.where((c) => c.isReadOnly == false).toList();
  List<Calendar> get _readOnlyCals =>
      _calendars.where((c) => c.isReadOnly == true).toList();

  _PhoneCalendarPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();
    _getCalendars();
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

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Container(
    //     child: SfCalendar(
    //       view: CalendarView.week,
    //       showNavigationArrow: true,
    //       showWeekNumber: true,
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _calendars.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  key: Key(_calendars[index].isReadOnly == true
                      ? 'readOnlyCalendar${_readOnlyCals.indexWhere((c) => c.id == _calendars[index].id)}'
                      : 'writableCalendar${_writableCals.indexWhere((c) => c.id == _calendars[index].id)}'),
                  onTap: () async {
                    if(_calendars[index].isReadOnly == false){
                      // Creates a new event at the given date and time
                      Location location = Location('Somewhere', [0], [0], [TimeZone.UTC]);
                      TZDateTime start = TZDateTime(location, 2022, 1, 23, 12, 30);
                      TZDateTime end = TZDateTime(location, 2022, 1, 23, 13);
                      Event event = Event(_calendars[index].id, title: 'ABBA', start: start, end: end);
                      var eventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
                      if(eventResult!.isSuccess && eventResult.data!.isNotEmpty){
                        print('Success!');
                      } else {
                        print(eventResult.data);
                      }

                      // var events = await _deviceCalendarPlugin.retrieveEvents(_calendars[index].id,
                      //     RetrieveEventsParams(startDate: DateTime.now(), endDate: DateTime(2023)));
                      // UnmodifiableListView<Event>? eventList = events.data;
                      // if(eventList != null){
                      //   for(Event e in eventList){
                      //     print(e.title);
                      //   }
                      // } else {
                      //   print("No events to print");
                      // }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            _calendars[index].name!,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(_calendars[index].color!)),
                        ),
                        SizedBox(width: 10),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)),
                          child: Text('Default'),
                        ),
                        Icon(_calendars[index].isReadOnly == true
                            ? Icons.lock
                            : Icons.lock_open)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
