import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/user.dart';

String currentDateFormat = defaultDateFormat;

final Map<String, String> dateFormats = {
  'M/d/yyyy': '11/1/2025',
  'd/M/yyyy': '1/11/2025',
  'yyyy/M/d': '2025/11/1',
  'MMM d, yyyy': 'Nov 1st, 2025',
  'd MMM, yyyy': '1st Nov, 2025',
  'yyyy, MMM d': '2025, Nov 1st',
};

String formatDate(DateTime date, {UserDetails? user}) {
  final String formatOfDate = user != null
      ? user.userProfile.dateFormat
      : defaultDateFormat;
  return DateFormat(formatOfDate).format(date);
}

DateTime parseDateString(String dateString, {UserDetails? user}) {
  if (dateString.contains('/')) {
    final String formatOfDate = user != null
        ? user.userProfile.dateFormat
        : defaultDateFormat;
    final DateFormat dateFormat = DateFormat(formatOfDate);
    return dateFormat.parse(dateString);
  }
  return DateTime.parse(dateString);
}

String extractDateTime(String dateTimeString, {UserDetails? userDetails}) {
  final String formatOfDate = userDetails != null
      ? userDetails.userProfile.dateFormat
      : defaultDateFormat;
  final String defaultDateAndTimeFormat = '$formatOfDate : $defaultTimeFormat';
  final DateFormat inputFormat = DateFormat(defaultDateAndTimeFormat);
  final DateTime dateTime = inputFormat.parse(dateTimeString);
  final DateFormat outputDateFormat = DateFormat(formatOfDate);
  final DateFormat outputTimeFormat = DateFormat(defaultTimeFormat);
  final String formattedDate = outputDateFormat.format(dateTime);
  final String formattedTime = outputTimeFormat.format(dateTime);
  return '$formattedDate $formattedTime';
}
