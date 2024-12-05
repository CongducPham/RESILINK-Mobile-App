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
  Function to transform a date string in the format "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
  into a date string in the format "dd/MM/yyyy at HH:mm".
 */
String formatDateToFullDate(String dateString) {
  DateTime dateObject = DateTime.parse(dateString);
  String formattedDate = "${DateFormat("dd/MM/yyyy").format(dateObject)} at ${DateFormat("HH:mm a").format(dateObject)}";
  return formattedDate;
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
