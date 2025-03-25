import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import '../custom_widgets/single_selection_date_picker.dart';
import '../custom_widgets/text_field.dart';
import '../models/user.dart';
import 'currency_and_data_format/date_format.dart';

Widget dateTextField({
  required TextEditingController dateController,
  required UserDetails userDetails,
  required BuildContext context,
  required String hintText,
  FocusNode? focusNode,
  String? errorMessage,
  ValueChanged<String>? onChanged,
  Widget? suffixIcon,
}) {
  return CustomTextField(
    controller: dateController,
    hintText: hintText,
    focusNode: FocusNode(),
    keyboardType: TextInputType.datetime,
    currentUserDetails: userDetails,
    isDate: true,
    errorMessage: errorMessage,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.singleLineFormatter,
      FilteringTextInputFormatter.allow(RegExp('[0-9/-]')),
    ],
    suffixIcon: IconButton(
      onPressed: () {
        showSingleDatePickerDialog(
          context,
          currentUserDetails: userDetails,
          onSingleDateSelected: (String selectedDate) {
            final DateFormat dateFormat = DateFormat(
              userDetails.userProfile.dateFormat,
            );

            final DateTime selectedDateTime = dateFormat.parse(selectedDate);

            final String formattedDate = formatDate(
              selectedDateTime,
              user: userDetails,
            );
            dateController.text = formattedDate;
          },
          enablePastDates: true,
        );
      },
      icon: const Icon(Icons.calendar_month),
    ),
  );
}
