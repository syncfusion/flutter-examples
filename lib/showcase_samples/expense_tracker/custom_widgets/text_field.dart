import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import '../helper/currency_and_data_format/date_format.dart';
import '../models/user.dart';
import 'single_selection_date_picker.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.focusNode,
    super.key,
    this.keyboardType,
    this.errorMessage,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.isDate = false,
    this.enabled,
    this.readOnly,
    this.canRequestFocus,
    this.onChanged,
    this.currentUserDetails,
    this.onSubmitted,
    this.isRequired = true,
    this.maxLines,
    this.mouseCursor,
    this.cursorColor,
    this.enableInteractiveSelection = true,
    this.showCursor = true,
  });

  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final String? errorMessage;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? readOnly;
  final bool? canRequestFocus;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDate;
  final ValueChanged<String>? onChanged;
  final UserDetails? currentUserDetails;
  final void Function(String)? onSubmitted;
  final bool isRequired;
  final int? maxLines;
  final MouseCursor? mouseCursor;
  final Color? cursorColor;
  final bool? enableInteractiveSelection;
  final bool? showCursor;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> _isFocusedNotifier;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode;
    _isFocusedNotifier = ValueNotifier<bool>(_focusNode.hasFocus);

    _focusNode.addListener(() {
      _isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {
      _isFocusedNotifier.value = _focusNode.hasFocus;
    });
    _isFocusedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    return ValueListenableBuilder<bool>(
      valueListenable: _isFocusedNotifier,
      builder: (context, isFocused, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: colorScheme.primary,
            ),
            tabBarTheme: TabBarThemeData(indicatorColor: colorScheme.onPrimary),
          ),
          child: TextField(
            maxLines: widget.maxLines,
            controller: widget.controller,
            focusNode: _focusNode,
            selectionControls: MaterialTextSelectionControls(),
            obscureText: widget.obscureText,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly ?? false,
            showCursor: widget.showCursor,
            mouseCursor: widget.mouseCursor,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            canRequestFocus: widget.canRequestFocus ?? true,
            onTapOutside: (PointerDownEvent event) {
              _focusNode.unfocus();
            },
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: RichText(
                text: TextSpan(
                  text: widget.hintText,
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: isFocused
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  children: <InlineSpan>[
                    if (widget.isRequired)
                      TextSpan(
                        text: '*',
                        style: themeData.textTheme.bodyMedium!.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              hintText: widget.hintText,
              hintStyle: themeData.textTheme.bodyLarge!.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 10.0,
                bottom: 10.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: colorScheme.error),
              ),
              errorText: widget.errorMessage,
              suffixIcon: widget.suffixIcon,
              enabled: widget.enabled ?? true,
            ),
          ),
        );
      },
    );
  }
}

Widget buildDateTextField({
  required TextEditingController dateController,
  required UserDetails userDetails,
  required BuildContext context,
  required String hintText,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  Widget? suffixIcon,
  bool canSelectFutureDate = false,
}) {
  return CustomTextField(
    controller: dateController,
    hintText: hintText,
    readOnly: true,
    canRequestFocus: false,
    cursorColor: Colors.transparent,
    showCursor: false,
    mouseCursor: MouseCursor.uncontrolled,
    enableInteractiveSelection: false,
    focusNode: FocusNode(),
    keyboardType: TextInputType.datetime,
    onChanged: onChanged,
    currentUserDetails: userDetails,
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
            if (onChanged != null) {
              onChanged(dateController.text);
            }
          },
          maxDates: canSelectFutureDate ? null : DateTime.now(),
          enablePastDates: true,
        );
      },
      icon: const Icon(Icons.calendar_month),
    ),
  );
}
