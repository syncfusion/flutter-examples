///flutter package import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

/// Renders the range slider with RTL text direction
class RangeSliderTextDirectionPage extends DirectionalitySampleView {
  /// Creates the range slider with RTL text direction
  const RangeSliderTextDirectionPage(Key key) : super(key: key);

  @override
  _RangeSliderTextDirectionPageState createState() =>
      _RangeSliderTextDirectionPageState();
}

class _RangeSliderTextDirectionPageState extends DirectionalitySampleViewState {
  _RangeSliderTextDirectionPageState();
  late String _numericTitle;
  late String _dateTitle;
  late ThemeData _themeData;
  SfRangeValues _numericRangeValues = const SfRangeValues(75.0, 125.0);
  SfRangeValues _dateRangeValues = SfRangeValues(
    DateTime(2005),
    DateTime(2015),
  );
  late ThemeData theme;

  SfRangeSliderTheme _numericRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        tooltipBackgroundColor: model.primaryColor,
        activeLabelStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        inactiveLabelStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tooltipTextStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      child: SfRangeSlider(
        min: 50,
        max: 150,
        values: _numericRangeValues,
        showLabels: true,
        interval: 25,
        showTicks: true,
        onChanged: (SfRangeValues values) {
          setState(() {
            _numericRangeValues = values;
          });
        },
        enableTooltip: true,
      ),
    );
  }

  SfRangeSliderTheme _dateTimeRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        tooltipBackgroundColor: model.primaryColor,
        activeLabelStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        inactiveLabelStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tooltipTextStyle: _themeData.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      child: SfRangeSlider(
        min: DateTime(2000),
        max: DateTime(2020),
        values: _dateRangeValues,
        showLabels: true,
        interval: 5,
        showTicks: true,
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        onChanged: (SfRangeValues values) {
          setState(() {
            _dateRangeValues = values;
          });
        },
        enableTooltip: true,
      ),
    );
  }

  Widget _buildWebLayout() {
    return Align(
      child: SizedBox(
        width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
        child: _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final double padding = MediaQuery.of(context).size.width / 20.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title(_numericTitle),
          columnSpacing10,
          _numericRangeSlider(),
          columnSpacing40,
          title(_dateTitle),
          columnSpacing10,
          _dateTimeRangeSlider(),
          columnSpacing40,
        ],
      ),
    );
  }

  void _updateTitleBasedOnLocale() {
    _themeData = Theme.of(context);
    if (model.locale == const Locale('ar', 'AE')) {
      _numericTitle = 'رقمي';
      _dateTitle = 'تاريخ';
    } else {
      _numericTitle = 'Numeric';
      _dateTitle = 'Date';
    }
  }

  @override
  Widget buildSample(BuildContext context) {
    _themeData = Theme.of(context);
    _updateTitleBasedOnLocale();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget rangeSlider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 300
            ? rangeSlider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: rangeSlider),
              );
      },
    );
  }
}
