import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_examples/model/model.dart';

// ignore: must_be_immutable
class RangeSliderDateTimeLabelPage extends StatefulWidget {
  RangeSliderDateTimeLabelPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSliderDateTimeLabelPageState createState() =>
      _RangeSliderDateTimeLabelPageState(sample);
}

class _RangeSliderDateTimeLabelPageState
    extends State<RangeSliderDateTimeLabelPage> {
  _RangeSliderDateTimeLabelPageState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return RangeSliderDateTimeLabelPageFrontPanel(sample);
  }
}

class RangeSliderDateTimeLabelPageFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  RangeSliderDateTimeLabelPageFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _RangeSliderDateTimeLabelPageFrontPanelState createState() =>
      _RangeSliderDateTimeLabelPageFrontPanelState(sampleList);
}

class _RangeSliderDateTimeLabelPageFrontPanelState
    extends State<RangeSliderDateTimeLabelPageFrontPanel> {
  _RangeSliderDateTimeLabelPageFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: MediaQuery.of(context).orientation == Orientation.portrait
          ? DateTimeRangeSlider()
          : SingleChildScrollView(child: Container(height: 300,child: DateTimeRangeSlider())
            ),
          );
  }
}

// ignore: must_be_immutable
class DateTimeRangeSlider extends StatefulWidget {
  @override
  _DateTimeRangeSliderState createState() => _DateTimeRangeSliderState();
}

class _DateTimeRangeSliderState extends State<DateTimeRangeSlider> {
  final DateTime _monthMin = DateTime(2001, 01, 01);
  final DateTime _monthMax = DateTime(2005, 01, 01);
  final DateTime _hourMin = DateTime(2010, 01, 01, 9, 00, 00);
  final DateTime _hourMax = DateTime(2010, 01, 01, 21, 05, 00);
  SfRangeValues _monthValues =
      SfRangeValues(DateTime(2002, 4, 01), DateTime(2003, 10, 01));
  SfRangeValues _hourValues = SfRangeValues(
      DateTime(2010, 01, 01, 13, 00, 00), DateTime(2010, 01, 01, 17, 00, 00));
  final double sizeBoxHeight = 40;

  Widget _getAlignedTextWidget(String text,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        padding: const EdgeInsets.only(left: 25),
      ),
    );
  }

  SfRangeSliderTheme dateTimeMonthRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        brightness: Theme.of(context).brightness,
        labelOffset: const Offset(0, 5),
      ),
      child: SfRangeSlider(
        min: _monthMin,
        max: _monthMax,
        showLabels: true,
        interval: 1,
        dateFormat: DateFormat.y(),
        labelPlacement: LabelPlacement.betweenTicks,
        dateIntervalType: DateIntervalType.years,
        showTicks: true,
        values: _monthValues,
        onChanged: (dynamic value) {
          setState(() {
            _monthValues = value;
          });
        },
        showTooltip: true,
        tooltipTextFormatterCallback: (dynamic actual, String formatted){
          return DateFormat.yMMM().format(actual);
        },
      ),
    );
  }

  SfRangeSliderTheme dateTimeHoursRangeSlider() {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        brightness: Theme.of(context).brightness,
        labelOffset: const Offset(0, 6),
      ),
      child: SfRangeSlider(
        min: _hourMin,
        max: _hourMax,
        showLabels: true,
        interval: 4,
        showTicks: true,
        minorTicksPerInterval: 3,
        dateFormat: DateFormat('h a'),
        labelPlacement: LabelPlacement.onTicks,
        dateIntervalType: DateIntervalType.hours,
        values: _hourValues,
        onChanged: (dynamic value) {
          setState(() {
            _hourValues = value;
          });
        },
        showTooltip: true,
        tooltipTextFormatterCallback: (dynamic actual, String formatted){
          return DateFormat('h:mm a').format(actual);
        },
      ),
    );
  }

  Widget get sizedBox => SizedBox(height: sizeBoxHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getAlignedTextWidget('Interval as year'),
          const SizedBox(height: 10,),
          dateTimeMonthRangeSlider(),
          sizedBox,
          _getAlignedTextWidget('Interval as hour'),
          const SizedBox(height: 10,),
          dateTimeHoursRangeSlider(),
          sizedBox,
        ],
      ),
    );
  }
}
