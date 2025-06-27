/// Package import.
import 'package:flutter/material.dart';

/// Date picker import.
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// Local import
import '../../model/sample_view.dart';

/// Widget of date picker localization.
class DatePickerLocalization extends LocalizationSampleView {
  /// Creates default date picker localization.
  const DatePickerLocalization(Key key) : super(key: key);

  @override
  _PickerLocalizationState createState() => _PickerLocalizationState();
}

class _PickerLocalizationState extends LocalizationSampleViewState {
  late Orientation _deviceOrientation;

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    _controller.displayDate = DateTime.now();
    _controller.selectedDate = DateTime.now();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget buildSample(BuildContext context) {
    final Widget cardView = Card(
      elevation: 10,
      margin: model.isWebFullView
          ? const EdgeInsets.fromLTRB(30, 60, 30, 10)
          : const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        color: model.sampleOutputCardColor,
        child: Theme(
          data: model.themeData.copyWith(
            colorScheme: model.themeData.colorScheme.copyWith(
              secondary: model.primaryColor,
            ),
          ),
          child: _buildGettingStartedDatePicker(_controller, context),
        ),
      ),
    );
    return Scaffold(
      backgroundColor:
          model.themeData == null ||
              model.themeData.colorScheme.brightness == Brightness.light
          ? null
          : const Color(0x00171a21),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: model.isWebFullView ? 9 : 8,
            child: model.isWebFullView
                ? Center(
                    child: SizedBox(width: 400, height: 600, child: cardView),
                  )
                : ListView(
                    children: <Widget>[SizedBox(height: 450, child: cardView)],
                  ),
          ),
          Expanded(
            flex: model.isWebFullView
                ? 1
                : model.isMobileResolution &&
                      _deviceOrientation == Orientation.landscape
                ? 0
                : 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  /// Returns the date range picker based on the properties passed.
  Widget _buildGettingStartedDatePicker(
    DateRangePickerController controller,
    BuildContext context,
  ) {
    return SfDateRangePicker(showNavigationArrow: true, controller: controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
