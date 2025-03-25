import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../helper/common_center_dialog.dart';
import '../models/user.dart';
import '../notifiers/setup_notifier.dart';

Future<void> showSingleDatePickerDialog(
  BuildContext context, {
  required void Function(String) onSingleDateSelected,
  required bool enablePastDates,
  UserDetails? currentUserDetails,
  DateTime? maxDates,
  bool isSetupPage = false,
}) async {
  final DateTime? picked = await _showDialog(
    context,
    maxDates,
    enablePastDates: enablePastDates,
    isSetupPage: isSetupPage,
  );
  if (picked != null) {
    String formattedDate = '';
    if (currentUserDetails != null) {
      formattedDate = DateFormat(
        currentUserDetails.userProfile.dateFormat,
      ).format(picked);
    } else {
      formattedDate = DateFormat('M/d/yyyy').format(picked);
    }
    onSingleDateSelected(formattedDate);
  }
}

Future<DateTime?> _showDialog(
  BuildContext context,
  DateTime? maxDate, {
  required bool enablePastDates,
  bool isSetupPage = false,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return CommonCenterDialog(
        content: SizedBox(
          width: 350,
          height: 350,
          child: _buildDatePicker(
            context,
            enablePastDates,
            maxDate,
            isSetupPage,
          ),
        ),
      );
    },
  );
}

Widget _buildDatePicker(
  BuildContext context,
  bool enablePastDates,
  DateTime? maxDate,
  bool isSetupPage,
) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
    ),
    child: SfDateRangePicker(
      backgroundColor: Colors.transparent,
      headerStyle: const DateRangePickerHeaderStyle(
        backgroundColor: Colors.transparent,
      ),
      headerHeight: 60,
      maxDate: maxDate,
      enablePastDates: enablePastDates,
      initialDisplayDate: DateTime.now(),
      cancelText: 'Cancel',
      showNavigationArrow: true,
      showActionButtons: true,
      onSubmit: (Object? value) {
        if (value is DateTime) {
          Navigator.pop(context, value);
          if (isSetupPage) {
            Provider.of<SetupNotifier>(
              context,
              listen: false,
            ).validateNextButton();
          }
        }
      },
      onCancel: () {
        Navigator.pop(context);
      },
    ),
  );
}
