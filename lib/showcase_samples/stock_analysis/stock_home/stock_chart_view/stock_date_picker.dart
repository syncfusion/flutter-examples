import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../enum.dart';
import '../../helper/helper.dart';
import '../../helper/responsive_layout.dart';
import '../../notifier/stock_chart_notifier.dart';

class ExtendableRangeSelectionDatepickerDialog extends StatefulWidget {
  const ExtendableRangeSelectionDatepickerDialog({
    super.key,
    required this.onRangeDateSelected,
  });

  final Function(DateTime, DateTime) onRangeDateSelected;

  @override
  ExtendableRangeSelectionDatepickerDialogState createState() =>
      ExtendableRangeSelectionDatepickerDialogState();
}

class ExtendableRangeSelectionDatepickerDialogState
    extends State<ExtendableRangeSelectionDatepickerDialog> {
  List<DateTime?> pickedDates = [null, null];
  bool _isDesktop = false;

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(),
          buildCloseIconButton(context, () {
            Navigator.of(context).pop();
          }),
        ],
      ),
    );
  }

  void handleTodayButtonPressed(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime todayStart = DateTime(today.year, today.month, today.day);
    widget.onRangeDateSelected(todayStart, today);
    Navigator.pop(context);
  }

  void handleApplyButtonPressed(BuildContext context) {
    if (pickedDates.isNotEmpty &&
        pickedDates[0] != null &&
        pickedDates[1] != null) {
      widget.onRangeDateSelected(pickedDates[0]!, pickedDates[1]!);
      Navigator.pop(context);
    }
  }

  Widget _buildTitle() {
    return Text(
      'Date Range',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: _isDesktop ? EdgeInsets.zero : const EdgeInsets.only(top: 18),
      child: _buildDatePickerView(),
    );
  }

  Widget _buildDatePickerView() {
    final DateTime initialDisplayDate1 = DateTime.now();
    final DateTime initialDisplayDate2 = DateTime.now().add(
      const Duration(days: 30),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 2),
      height: _isDesktop ? 500 : 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isDesktop) ...[
            _buildDateDisplayRow(
              context,
              initialDisplayDate1,
              initialDisplayDate2,
            ),
            _buildDateDifferenceRow(
              context,
              initialDisplayDate1,
              initialDisplayDate2,
            ),
          ],
          _buildDatePicker(context, setState),
        ],
      ),
    );
  }

  Widget _buildDateDisplayRow(
    BuildContext context,
    DateTime initialDisplayDate1,
    DateTime initialDisplayDate2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDateDisplayText(context, pickedDates[0] ?? initialDisplayDate1),
          const Icon(IconData(0xe70a, fontFamily: stockFontIconFamily)),
          _buildDateDisplayText(context, pickedDates[1] ?? initialDisplayDate2),
        ],
      ),
    );
  }

  Widget _buildDateDisplayText(BuildContext context, DateTime date) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        DateFormat('dd/MM/yyyy').format(date),
        textAlign: TextAlign.center,
        style: themeData.textTheme.titleMedium?.copyWith(
          color: themeData.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildDateDifferenceRow(
    BuildContext context,
    DateTime initialDisplayDate1,
    DateTime initialDisplayDate2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDateDifferenceText(initialDisplayDate1, initialDisplayDate2),
        ],
      ),
    );
  }

  Widget _buildDateDifferenceText(
    DateTime initialDisplayDate1,
    DateTime initialDisplayDate2,
  ) {
    final ThemeData themeData = Theme.of(context);
    return Text(
      pickedDates[0] != null && pickedDates[1] != null
          ? '${pickedDates[1]!.difference(pickedDates[0]!).abs().inDays} days'
          : '${initialDisplayDate2.difference(initialDisplayDate1).abs().inDays} days',
      style: themeData.textTheme.bodySmall?.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, StateSetter setState) {
    return _isDesktop
        ? _buildDesktopDatePicker(context, setState)
        : _buildMobileDatePicker(context, setState);
  }

  Widget _buildDesktopDatePicker(BuildContext context, StateSetter setState) {
    final ThemeData themeData = Theme.of(context);
    final StockChartProvider provider = context.read<StockChartProvider>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SfDateRangePicker(
          backgroundColor: themeData.colorScheme.surface,
          initialDisplayDate: DateTime.now(),
          headerHeight: 60,
          selectionMode: DateRangePickerSelectionMode.extendableRange,
          onSelectionChanged: _handleSelectionChanged,
          enableMultiView: true,
          minDate: DateTime.parse(
            provider.viewModel.dataCollections.first.date,
          ),
          maxDate: DateTime(2025),
          monthCellStyle: _buildMonthCellStyle(themeData),
          headerStyle: _buildHeaderStyle(themeData),
          showNavigationArrow: true,
        ),
      ),
    );
  }

  Widget _buildMobileDatePicker(BuildContext context, StateSetter setState) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SfDateRangePicker(
          backgroundColor: themeData.colorScheme.surface,
          initialDisplayDate: DateTime.now(),
          headerHeight: 60,
          selectionMode: DateRangePickerSelectionMode.extendableRange,
          onSelectionChanged: _handleSelectionChanged,
          monthCellStyle: _buildMonthCellStyle(themeData),
          headerStyle: _buildHeaderStyle(themeData),
          showNavigationArrow: true,
        ),
      ),
    );
  }

  void _handleSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      pickedDates[0] = args.value.startDate;
      pickedDates[1] = args.value.endDate;
    });
  }

  DateRangePickerMonthCellStyle _buildMonthCellStyle(ThemeData themeData) {
    return DateRangePickerMonthCellStyle(
      textStyle: themeData.textTheme.bodySmall?.copyWith(
        color: themeData.colorScheme.onSurface,
        fontWeight: fontWeight500(),
      ),
    );
  }

  DateRangePickerHeaderStyle _buildHeaderStyle(ThemeData themeData) {
    return DateRangePickerHeaderStyle(
      backgroundColor: themeData.colorScheme.surface,
      textStyle: themeData.textTheme.labelLarge?.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
        fontWeight: fontWeight500(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildCancelButton(), _buildAddButton()],
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        'Cancel',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return TextButton(
      onPressed: () => handleApplyButtonPressed(context),
      child: Text(
        'Apply',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isDesktop = deviceType(context) == DeviceType.desktop;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      contentPadding: EdgeInsets.zero,
      title: _isDesktop ? buildHeader(context) : null,
      content: _buildContent(),
      actions: [_buildActionButtons(context)],
    );
  }
}
