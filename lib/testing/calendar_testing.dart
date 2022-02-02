/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/01/2022

// TESTING CODE, FOR REFERENCE
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:device_calendar/device_calendar.dart';

import 'package:timezone/src/date_time.dart';
import 'package:timezone/standalone.dart';

import 'package:capstone_project/widgets/calendar_data_source.dart';

Widget _testWidget(){
  var _calendars, _readOnlyCals, _writableCals, _deviceCalendarPlugin;
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
                    // USE calendar.accountType to only place outlook events into the calendar
                    print(_calendars[index].accountType);
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

                    var events = await _deviceCalendarPlugin.retrieveEvents(_calendars[index].id,
                        RetrieveEventsParams(startDate: DateTime.now(), endDate: DateTime(2023)));
                    UnmodifiableListView<Event>? eventList = events.data;
                    if(eventList != null){
                      for(Event e in eventList){
                        print(e.title);
                      }
                    } else {
                      print("No events to print");
                    }
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
// TESTING CODE, FOR REFERENCE