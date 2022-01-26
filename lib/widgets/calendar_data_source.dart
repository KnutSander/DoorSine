/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 26/01/2021

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CDS extends CalendarDataSource {
  CDS(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}