/// Dart import
import 'dart:math';

import 'package:flutter/material.dart';

/// Package imports
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the chart with crosshair sample.
class DefaultCrossHair extends SampleView {
  /// creates the chart with crosshair.
  const DefaultCrossHair(Key key) : super(key: key);

  @override
  _DefaultCrossHairState createState() => _DefaultCrossHairState();
}

/// State class of the chart with crosshair.
class _DefaultCrossHairState extends SampleViewState {
  _DefaultCrossHairState();
  late bool alwaysShow;
  late double duration;
  late List<String> _lineTypeList;
  late String _selectedLineType;
  late CrosshairLineType _lineType;
  late List<ChartSampleData> randomData;

  @override
  void initState() {
    _lineTypeList = <String>['both', 'vertical', 'horizontal'].toList();
    randomData = getDatatTimeData();
    _selectedLineType = 'both';
    _lineType = CrosshairLineType.both;
    duration = 2;
    alwaysShow = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: model.isWebFullView || !isCardView ? 0 : 60),
        child: _buildDefaultCrossHairChart());
  }

  @override
  void dispose() {
    _lineTypeList.clear();
    randomData.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text('Line type',
                  softWrap: false,
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              Container(
                  height: 50.0,
                  padding: !model.isWebFullView
                      ? const EdgeInsets.fromLTRB(65, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(42, 0, 0, 0),
                  child: DropdownButton<String>(
                      focusColor: Colors.transparent,
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedLineType,
                      items: _lineTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'both',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (dynamic value) {
                        onLineTypeChange(value);
                        stateSetter(() {});
                      })),
            ],
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text(model.isWebFullView ? 'Show \nalways' : 'Show always',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 16,
                    color: model.textColor,
                  )),
              Container(
                  height: 50.0,
                  padding: !model.isWebFullView
                      ? const EdgeInsets.fromLTRB(25, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(55, 0, 0, 0),
                  child: Checkbox(
                      activeColor: model.backgroundColor,
                      value: alwaysShow,
                      onChanged: (bool? value) {
                        setState(() {
                          alwaysShow = value!;
                          stateSetter(() {});
                        });
                      })),
            ],
          ),
          Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text('Hide delay  ',
                  softWrap: false,
                  style: TextStyle(fontSize: 16, color: model.textColor)),
              Container(
                height: 50.0,
                padding: !model.isWebFullView
                    ? const EdgeInsets.fromLTRB(32, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: CustomDirectionalButtons(
                  maxValue: 10,
                  initialValue: duration,
                  onChanged: (double val) => setState(() {
                    duration = val;
                  }),
                  step: 2,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  /// Returns the cartesian chart with crosshair.
  SfCartesianChart _buildDefaultCrossHairChart() {
    _lineType = _lineType;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interactiveTooltip: InteractiveTooltip(
              enable: (_lineType == CrosshairLineType.both ||
                      _lineType == CrosshairLineType.vertical)
                  ? true
                  : false)),

      /// To enable the cross hair for cartesian chart.
      crosshairBehavior: CrosshairBehavior(
          enable: true,
          hideDelay: duration * 1000,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: alwaysShow,
          lineType: _lineType),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interactiveTooltip: InteractiveTooltip(
              enable: (_lineType == CrosshairLineType.both ||
                      _lineType == CrosshairLineType.horizontal)
                  ? true
                  : false),
          majorTickLines: const MajorTickLines(width: 0)),
      series: getDefaultCrossHairSeries(),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the Cartesian chart.
  List<LineSeries<ChartSampleData, DateTime>> getDefaultCrossHairSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
          dataSource: randomData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2)
    ];
  }

  /// Method the update the crosshair line type in the chart on change.
  void onLineTypeChange(String item) {
    _selectedLineType = item;
    if (_selectedLineType == 'both') {
      _lineType = CrosshairLineType.both;
    }
    if (_selectedLineType == 'horizontal') {
      _lineType = CrosshairLineType.horizontal;
    }
    if (_selectedLineType == 'vertical') {
      _lineType = CrosshairLineType.vertical;
    }
    setState(() {
      /// update the crosshair line type changes
    });
  }
}

/// Method to get random data points for the chart with crosshair sample.
List<ChartSampleData> getDatatTimeData() {
  final List<ChartSampleData> randomData = <ChartSampleData>[];
  final Random rand = Random();
  double value = 100;
  for (int i = 1; i < 2000; i++) {
    if (rand.nextDouble() > 0.5) {
      value += rand.nextDouble();
    } else {
      value -= rand.nextDouble();
    }
    randomData.add(ChartSampleData(x: DateTime(1900, i), y: value));
  }
  return randomData;
}
