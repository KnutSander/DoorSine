/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2022

// Imports
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Custom calendar data source needed to import and display calendar events
class CDS extends CalendarDataSource {
  CDS(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}
