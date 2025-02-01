import 'package:intl/intl.dart';

class DateFormate {
  static DateFormat displayDateFormate = DateFormat("dd MMM, yyyy");

  static DateFormat normalDateFormate = DateFormat('dd/MM/yyyy');
  static DateFormat databaseFormate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat onlyTimeFormate = DateFormat('hh:mm:ss a');

  static DateFormat databaseDateFormate = DateFormat('MM/dd/yyyy hh:mm:ss a');
  static DateFormat longDateFormate = DateFormat('MMMM d, EEEE');

  static DateFormat newDateFormate = DateFormat('dd-MM-yyyy');

  static DateFormat onlyMonthFormate = DateFormat('MMM dd');

  static parsedTime(String timeString, {bool isUtc = false}) {
    DateTime parsedTime = DateTime.parse(timeString).copyWith(isUtc: isUtc);
    return parsedTime;
  }

  static String timeHrFormat(dynamic agoDate) {
    DateTime agoDt = parsedTime(agoDate);
    DateTime currentDate = DateTime.now();

    if (agoDt.isAfter(currentDate)) {
      return "-";
    }

    Duration difference = currentDate.difference(agoDt);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays == 1 ? '' : 's'}";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}";
    } else {
      return "Just now";
    }
  }
}
