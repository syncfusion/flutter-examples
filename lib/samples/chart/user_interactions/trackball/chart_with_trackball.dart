/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/widgets/checkbox.dart';
import 'package:flutter_examples/widgets/customDropDown.dart';
import 'package:flutter_examples/widgets/custom_button.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/shared/mobile.dart'
    if (dart.library.html) 'package:flutter_examples/widgets/shared/web.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with default trackball sample.
class DefaultTrackball extends SampleView {
  const DefaultTrackball(Key key) : super(key: key);

  @override
  _DefaultTrackballState createState() => _DefaultTrackballState();
}

/// State class the chart with default trackball.
class _DefaultTrackballState extends SampleViewState {
  _DefaultTrackballState();
  double duration = 2;
  bool showAlways = false;
  final List<String> _modeList =
      <String>['floatAllPoints', 'groupAllPoints', 'nearestPoint'].toList();
  String _selectedMode = 'floatAllPoints';

  TrackballDisplayMode _mode = TrackballDisplayMode.floatAllPoints;

  final List<String> _alignmentList =
      <String>['center', 'far', 'near'].toList();
  String _tooltipAlignment = 'center';

  ChartAlignment _alignment = ChartAlignment.center;

  @override
  void initState() {
    duration = 2;
    showAlways = false;
    _selectedMode = 'floatAllPoints';
    _mode = TrackballDisplayMode.floatAllPoints;
    _tooltipAlignment = 'center';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getDefaultTrackballChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: 110,
              child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Mode ',
                              style: TextStyle(
                                  color: model.textColor,
                                  fontSize: 16,
                                  letterSpacing: 0.34,
                                  fontWeight: FontWeight.normal)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                            height: 50,
                            width: 280,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      canvasColor:
                                          model.bottomSheetBackgroundColor),
                                  child: DropDown(
                                      value: _selectedMode,
                                      item: _modeList.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'point',
                                            child: Text('$value',
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                      valueChanged: (dynamic value) {
                                        setState(() {
                                          onModeTypeChange(value);
                                        });
                                      })),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Alignment',
                              style: TextStyle(
                                  color: _selectedMode != 'groupAllPoints'
                                      ? const Color.fromRGBO(0, 0, 0, 0.3)
                                      : model.textColor,
                                  fontSize: 16,
                                  letterSpacing: 0.34,
                                  fontWeight: FontWeight.normal)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                            height: 50,
                            width: 150,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      canvasColor:
                                          model.bottomSheetBackgroundColor),
                                  child: DropDown(
                                      value: _tooltipAlignment,
                                      item: _selectedMode != 'groupAllPoints'
                                          ? null
                                          : _alignmentList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                  value: (value != null)
                                                      ? value
                                                      : 'center',
                                                  child: Text('$value',
                                                      style: TextStyle(
                                                          color: model
                                                              .textColor)));
                                            }).toList(),
                                      valueChanged: (dynamic value) {
                                        onAlignmentChange(value);
                                      })),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]));
        }),
        Container(
          child: Row(
            children: <Widget>[
              Text('Show always ',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              HandCursor(
                child: BottomSheetCheckbox(
                  activeColor: model.backgroundColor,
                  switchValue: showAlways,
                  valueChanged: (dynamic value) {
                    setState(() {
                      showAlways = value;
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

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart getDefaultTrackballChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Average sales per person'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Revenue'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0)),
      series: getDefaultTrackballSeries(),
      /// To set the track ball as true and customized trackball behaviour.
      trackballBehavior: TrackballBehavior(
        enable: true,
        hideDelay: (duration ?? 2.0) * 1000,
        lineType: TrackballLineType.vertical,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _alignment,
        tooltipDisplayMode: _mode,
        tooltipSettings: InteractiveTooltip(format: 'point.x: point.y'),
        shouldAlwaysShow: isCardView ? true : (showAlways ?? true),
      ),
    );
  }

  /// Returns the list of chart which need to render  on the cartesian chart.
  List<LineSeries<ChartSampleData, DateTime>> getDefaultTrackballSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2000, 2, 11), y: 15, yValue2: 39, yValue3: 60),
      ChartSampleData(
          x: DateTime(2000, 9, 14), y: 20, yValue2: 30, yValue3: 55),
      ChartSampleData(
          x: DateTime(2001, 2, 11), y: 25, yValue2: 28, yValue3: 48),
      ChartSampleData(
          x: DateTime(2001, 9, 16), y: 21, yValue2: 35, yValue3: 57),
      ChartSampleData(x: DateTime(2002, 2, 7), y: 13, yValue2: 39, yValue3: 62),
      ChartSampleData(x: DateTime(2002, 9, 7), y: 18, yValue2: 41, yValue3: 64),
      ChartSampleData(
          x: DateTime(2003, 2, 11), y: 24, yValue2: 45, yValue3: 57),
      ChartSampleData(
          x: DateTime(2003, 9, 14), y: 23, yValue2: 48, yValue3: 53),
      ChartSampleData(x: DateTime(2004, 2, 6), y: 19, yValue2: 54, yValue3: 63),
      ChartSampleData(x: DateTime(2004, 9, 6), y: 31, yValue2: 55, yValue3: 50),
      ChartSampleData(
          x: DateTime(2005, 2, 11), y: 39, yValue2: 57, yValue3: 66),
      ChartSampleData(
          x: DateTime(2005, 9, 11), y: 50, yValue2: 60, yValue3: 65),
      ChartSampleData(
          x: DateTime(2006, 2, 11), y: 24, yValue2: 60, yValue3: 79),
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2,
          name: 'John',
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          width: 2,
          name: 'Andrew',
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: 'Thomas',
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }

  /// Method to update the trackball display mode in the chart on change.
  void onModeTypeChange(String item) {
    _selectedMode = item;
    if (_selectedMode == 'floatAllPoints') {
      _mode = TrackballDisplayMode.floatAllPoints;
    }
    if (_selectedMode == 'groupAllPoints') {
      _mode = TrackballDisplayMode.groupAllPoints;
    }
    if (_selectedMode == 'nearestPoint') {
      _mode = TrackballDisplayMode.nearestPoint;
    }
    if (_selectedMode == 'none') {
      _mode = TrackballDisplayMode.none;
    }
    setState(() {});
  }

  /// Method to update the chart alignment for tooltip in the chart on change.
  void onAlignmentChange(String item) {
    _tooltipAlignment = item;
    if (_tooltipAlignment == 'center') {
      _alignment = ChartAlignment.center;
    }
    if (_tooltipAlignment == 'far') {
      _alignment = ChartAlignment.far;
    }
    if (_tooltipAlignment == 'near') {
      _alignment = ChartAlignment.near;
    }
    setState(() {});
  }
}