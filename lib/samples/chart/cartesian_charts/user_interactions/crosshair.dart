/// Dart imports.
import 'dart:math';
import 'package:flutter/material.dart';

/// Package import.
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the line series chart with crosshair.
class DefaultCrossHair extends SampleView {
  /// creates the line series chart with crosshair.
  const DefaultCrossHair(Key key) : super(key: key);

  @override
  _DefaultCrossHairState createState() => _DefaultCrossHairState();
}

/// State class for the line series chart with crosshair.
class _DefaultCrossHairState extends SampleViewState {
  _DefaultCrossHairState();

  late bool _shouldAlwaysShow;
  late double _hideDelayDuration;
  late List<String> _lineTypeList;
  late String _selectedLineType;
  late CrosshairLineType _crosshairLineType;
  late List<ChartSampleData> _randomData;

  @override
  void initState() {
    _lineTypeList = <String>['both', 'vertical', 'horizontal'].toList();
    _randomData = _buildChartData();
    _selectedLineType = 'both';
    _crosshairLineType = CrosshairLineType.both;
    _hideDelayDuration = 2;
    _shouldAlwaysShow = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 60,
      ),
      child: _buildDefaultCrossHairChart(),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildLineTypeSetting(stateSetter),
            _buildShowAlwaysSetting(stateSetter),
            _buildHideDelaySetting(),
          ],
        );
      },
    );
  }

  /// Builds the row for selecting the line type in the chart.
  Widget _buildLineTypeSetting(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Text(
          'Line type',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          height: 50.0,
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(65, 0, 0, 0)
              : const EdgeInsets.fromLTRB(42, 0, 0, 0),
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedLineType,
            items: _lineTypeList.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'both',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (dynamic value) {
              _updateLineType(value);
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Builds the row for showing the option to always display the crosshair.
  Widget _buildShowAlwaysSetting(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Text(
          model.isWebFullView ? 'Show \nalways' : 'Show always',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          height: 50.0,
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(25, 0, 0, 0)
              : const EdgeInsets.fromLTRB(55, 0, 0, 0),
          child: Checkbox(
            activeColor: model.primaryColor,
            value: _shouldAlwaysShow,
            onChanged: (bool? value) {
              setState(() {
                _shouldAlwaysShow = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the row for setting the hide delay duration for the crosshair.
  Widget _buildHideDelaySetting() {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Text(
          'Hide delay  ',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          height: 50.0,
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(32, 0, 0, 0)
              : const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: CustomDirectionalButtons(
            maxValue: 10,
            initialValue: _hideDelayDuration,
            onChanged: (double val) => setState(() {
              _hideDelayDuration = val;
            }),
            step: 2,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian line chart with crosshair.
  SfCartesianChart _buildDefaultCrossHairChart() {
    _crosshairLineType = _crosshairLineType;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.y(),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interactiveTooltip: InteractiveTooltip(
          enable:
              (_crosshairLineType == CrosshairLineType.both ||
                  _crosshairLineType == CrosshairLineType.vertical)
              ? true
              : false,
        ),
      ),

      /// To enable the cross hair for cartesian chart.
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        hideDelay: _hideDelayDuration * 1000,
        activationMode: ActivationMode.singleTap,
        shouldAlwaysShow: _shouldAlwaysShow,
        lineType: _crosshairLineType,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        interactiveTooltip: InteractiveTooltip(
          enable:
              (_crosshairLineType == CrosshairLineType.both ||
                  _crosshairLineType == CrosshairLineType.horizontal)
              ? true
              : false,
        ),
        majorTickLines: const MajorTickLines(width: 0),
      ),
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _randomData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
      ),
    ];
  }

  /// Method to update the crosshair line type in the chart on change.
  void _updateLineType(String item) {
    _selectedLineType = item;
    if (_selectedLineType == 'both') {
      _crosshairLineType = CrosshairLineType.both;
    }
    if (_selectedLineType == 'horizontal') {
      _crosshairLineType = CrosshairLineType.horizontal;
    }
    if (_selectedLineType == 'vertical') {
      _crosshairLineType = CrosshairLineType.vertical;
    }
    setState(() {
      /// update the crosshair line type changes.
    });
  }
}

/// Method to get random data points for the chart with crosshair sample.
List<ChartSampleData> _buildChartData() {
  final List<ChartSampleData> randomData = <ChartSampleData>[];
  final Random rand = Random.secure();
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
