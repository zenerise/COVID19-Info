import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:covid19info/daily/models/calendar.dart';

class CalendarViews {
  Widget display() {
    return TableCalendar(calendarController: CalendarModel.calendar);
  }
}
