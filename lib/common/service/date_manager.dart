/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
import 'package:intl/intl.dart';

/*
  Function to modify the date in parameter including its year,
  month and day by adding the value "value" according to the unit set in parameter.
 */
DateTime addDurationToDate(int value, String unit, DateTime date) {
  if (unit == "day") {
    return date.add(Duration(days: value));
  } else if (unit == "week") {
    return date.add(Duration(days: value * 7));
  } else if (unit == "month") {
    return DateTime(date.year, date.month + value, date.day);
  } else {
    throw Exception("Invalid unit");
  }
}

/*
   Function to check that one minute has passed between the start of the parameter date
   and the current date in GMT+1
 */
bool isOneMinutePassed(String date) {
  DateTime parsedDate = DateTime.parse(date);
  DateTime now = DateTime.now().toUtc();
  DateTime nowGmt1 = now.add(Duration(hours: 1));
  Duration difference = nowGmt1.difference(parsedDate);

  return difference.inMinutes >= 1;
}

/*
  Function to retrieve the time of the GMT+1 time zone with an extra 1 minute
  to allow for a margin of error in beginTimeSlot assignments.
 */
String dateToGMTPlus1() {
  DateTime now = DateTime.now().toUtc();
  DateTime gmtPlusOne = now.add(Duration(hours: 1));
  DateTime finalDate = gmtPlusOne.add(Duration(minutes: 1));
  String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(finalDate);
  return formattedDate;
}
