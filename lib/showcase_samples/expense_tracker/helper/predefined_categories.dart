import 'package:intl/intl.dart';

import '../models/user.dart';

UserDetails? currentUserDetails;
UserDetails findUserDetails(UserDetails userDetails) {
  currentUserDetails = userDetails;
  return currentUserDetails!;
}

String formatDate(DateTime date) {
  return DateFormat('M/d/yyyy').format(date);
}
