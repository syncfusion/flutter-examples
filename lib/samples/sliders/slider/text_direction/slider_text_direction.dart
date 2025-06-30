import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' hide TextDirection;

///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local imports
import '../../../../model/sample_view.dart';
import '../../slider_utils.dart';

///Render Slider with RTL text direction
class SliderTextDirectionPage extends DirectionalitySampleView {
  ///Creates Slider with RTL text direction
  const SliderTextDirectionPage(Key key) : super(key: key);

  @override
  _SliderTextDirectionPageState createState() =>
      _SliderTextDirectionPageState();
}

class _SliderTextDirectionPageState extends DirectionalitySampleViewState {
  _SliderTextDirectionPageState();
  late String _numericTitle;
  late String _dateTitle;
  late ThemeData _themeData;
  double _numericSliderValue = 100.0;
  DateTime _dateSliderValue = DateTime(2010);

  SfSliderTheme _numericSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(
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
      child: SfSlider(
        min: 50,
        max: 150,
        value: _numericSliderValue,
        showLabels: true,
        interval: 25,
        showTicks: true,
        onChanged: (dynamic value) {
          setState(() {
            _numericSliderValue = value as double;
          });
        },
        enableTooltip: true,
      ),
    );
  }

  SfSliderTheme _dateTimeSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(
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
      child: SfSlider(
        min: DateTime(2000),
        max: DateTime(2020),
        value: _dateSliderValue,
        showLabels: true,
        interval: 5,
        showTicks: true,
        dateFormat: DateFormat.y(),
        dateIntervalType: DateIntervalType.years,
        onChanged: (dynamic value) {
          setState(() {
            _dateSliderValue = value as DateTime;
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
          _numericSlider(),
          columnSpacing40,
          title(_dateTitle),
          columnSpacing10,
          _dateTimeSlider(),
          columnSpacing40,
        ],
      ),
    );
  }

  void _updateTitleBasedOnLocale() {
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
        final Widget slider = model.isWebFullView
            ? _buildWebLayout()
            : _buildMobileLayout();
        return constraints.maxHeight > 300
            ? slider
            : SingleChildScrollView(
                child: SizedBox(height: 300, child: slider),
              );
      },
    );
  }
}
