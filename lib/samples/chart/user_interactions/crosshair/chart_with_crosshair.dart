/// Dart import
import 'dart:math';

/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with crosshair sample.
class DefaultCrossHair extends SampleView {
  const DefaultCrossHair(Key key) : super(key: key);

  @override
  _DefaultCrossHairState createState() => _DefaultCrossHairState();
}

/// State class of the chart with crosshair.
class _DefaultCrossHairState extends SampleViewState {
  _DefaultCrossHairState();
  bool alwaysShow = false;
  double duration = 2;
  final List<String> _lineTypeList =
      <String>['both', 'vertical', 'horizontal'].toList();
  String _selectedLineType = 'both';
  CrosshairLineType _lineType = CrosshairLineType.both;
  dynamic randomData = getDatatTimeData();

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
    return getDefaultCrossHairChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Text('Line type        ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                height: 50,
                width: 150,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: model.bottomSheetBackgroundColor),
                      child: DropDown(
                          value: _selectedLineType,
                          item: _lineTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                                value: (value != null) ? value : 'both',
                                child: Text('$value',
                                    style: TextStyle(color: model.textColor)));
                          }).toList(),
                          valueChanged: (dynamic value) {
                            onLineTypeChange(value);
                          })),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Show always  ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              HandCursor(
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: alwaysShow,
                  valueChanged: (dynamic value) {
                    setState(() {
                      alwaysShow = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Hide delay  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: HandCursor(
                                      child: CustomButton(
                      minValue: 0,
                      maxValue: 10,
                      initialValue: duration,
                      onChanged: (dynamic val) => setState(() {
                        duration = val;
                      }),
                      step: 2,
                      horizontal: true,
                      loop: true,
                      padding: 0,
                      iconUpRightColor: model.textColor,
                      iconDownLeftColor: model.textColor,
                      style: TextStyle(fontSize: 20.0, color: model.textColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian chart with crosshair. 
  SfCartesianChart getDefaultCrossHairChart() {
    _lineType = _lineType ?? CrosshairLineType.both;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interactiveTooltip: InteractiveTooltip(
              enable: (isCardView ||
                      _lineType == CrosshairLineType.both ||
                      _lineType == CrosshairLineType.vertical)
                  ? true
                  : false)),
      /// To enable the cross hair for cartesian chart.
      crosshairBehavior: CrosshairBehavior(
          enable: true,
          hideDelay: (duration ?? 2.0) * 1000,
          lineWidth: 1,
          activationMode: ActivationMode.singleTap,
          shouldAlwaysShow: isCardView ? true : alwaysShow ?? true,
          lineType: isCardView ? CrosshairLineType.both : _lineType),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          interactiveTooltip: InteractiveTooltip(
              enable: (isCardView ||
                      _lineType == CrosshairLineType.both ||
                      _lineType == CrosshairLineType.horizontal)
                  ? true
                  : false),
          majorTickLines: MajorTickLines(width: 0)),
      series: getDefaultCrossHairSeries(),
    );
  }

  /// Returns the list of chart series which need to render on the Cartesian chart.
  List<LineSeries<ChartSampleData, DateTime>> getDefaultCrossHairSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
          dataSource: isCardView ? getDatatTimeData() : randomData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
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
    setState(() {});
  }
}

/// Method to get random data points for the chart with crosshair sample.
dynamic getDatatTimeData() {
  final List<ChartSampleData> _randomData = <ChartSampleData>[];
  final Random _rand = Random();
  double _value = 100;
  for (int i = 1; i < 2000; i++) {
    if (_rand.nextDouble() > 0.5)
      _value += _rand.nextDouble();
    else
      _value -= _rand.nextDouble();

    _randomData.add(ChartSampleData(x: DateTime(1900, i, 1), y: _value));
  }
  return _randomData;
}