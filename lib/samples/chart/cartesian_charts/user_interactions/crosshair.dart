/// Dart import
import 'dart:math';

/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

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
  final List<String> _lineTypeList =
      <String>['both', 'vertical', 'horizontal'].toList();
  late String _selectedLineType;
  late CrosshairLineType _lineType;
  List<ChartSampleData> randomData = getDatatTimeData();

  @override
  void initState() {
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
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Line type', style: TextStyle(color: model.textColor)),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.5 * screenWidth,
                height: 50,
                alignment: Alignment.bottomLeft,
                child: DropdownButton<String>(
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
          ),
          ListTile(
              title: Text('Show always',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                  padding: EdgeInsets.only(left: 0.05 * screenWidth),
                  width: 0.5 * screenWidth,
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: model.backgroundColor,
                      value: alwaysShow,
                      onChanged: (bool? value) {
                        setState(() {
                          alwaysShow = value!;
                          stateSetter(() {});
                        });
                      }))),
          ListTile(
            title:
                Text('Hide delay  ', style: TextStyle(color: model.textColor)),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
          lineWidth: 1,
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
  final List<ChartSampleData> _randomData = <ChartSampleData>[];
  final Random _rand = Random();
  double _value = 100;
  for (int i = 1; i < 2000; i++) {
    if (_rand.nextDouble() > 0.5) {
      _value += _rand.nextDouble();
    } else {
      _value -= _rand.nextDouble();
    }
    _randomData.add(ChartSampleData(x: DateTime(1900, i, 1), y: _value));
  }
  return _randomData;
}
