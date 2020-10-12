/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/checkbox.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';

/// Renders the chart with default trackball sample.
class DefaultTrackball extends SampleView {
  /// Creates the chart with default trackball sample.
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
  bool _showMarker;
  ChartAlignment _alignment = ChartAlignment.center;

  @override
  void initState() {
    duration = 2;
    showAlways = false;
    _selectedMode = 'floatAllPoints';
    _mode = TrackballDisplayMode.floatAllPoints;
    _tooltipAlignment = 'center';
    _showMarker = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: model.isWeb ? 0 : 60),
        child: _getDefaultTrackballChart());
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
                                      ? model.themeData.brightness ==
                                              Brightness.dark
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 0.3)
                                          : const Color.fromRGBO(0, 0, 0, 0.3)
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
                                  child: DropdownButtonFormField(
                                      disabledHint: Text(
                                        'center',
                                        style: TextStyle(
                                            color: _selectedMode !=
                                                    'groupAllPoints'
                                                ? model.themeData.brightness ==
                                                        Brightness.dark
                                                    ? const Color.fromRGBO(
                                                        255, 255, 255, 0.3)
                                                    : const Color.fromRGBO(
                                                        0, 0, 0, 0.3)
                                                : model.textColor),
                                      ),
                                      value: _tooltipAlignment,
                                      items: _alignmentList.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'center',
                                            child: Text('$value',
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                      onChanged:
                                          _selectedMode != 'groupAllPoints'
                                              ? null
                                              : (dynamic value) {
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
                child: CustomCheckBox(
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
                  padding: const EdgeInsets.fromLTRB(44, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
                      maxValue: 10,
                      initialValue: duration,
                      onChanged: (double val) => setState(() {
                        duration = val;
                      }),
                      step: 2,
                      padding: 0,
                      iconColor: model.textColor,
                      style: TextStyle(fontSize: 20.0, color: model.textColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Show track\nmarker',
                  style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: CustomCheckBox(
                    activeColor: model.backgroundColor,
                    switchValue: _showMarker,
                    valueChanged: (dynamic value) {
                      setState(() {
                        _showMarker = value;
                      });
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart _getDefaultTrackballChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Average sales per person'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          interval: 1,
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Revenue'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(width: 0)),
      series: _getDefaultTrackballSeries(),

      /// To set the track ball as true and customized trackball behaviour.
      trackballBehavior: TrackballBehavior(
        enable: true,
        markerSettings: TrackballMarkerSettings(
          markerVisibility: _showMarker
              ? TrackballVisibilityMode.visible
              : TrackballVisibilityMode.hidden,
          height: 10,
          width: 10,
          borderWidth: 1,
        ),
        hideDelay: (duration ?? 2.0) * 1000,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _alignment,
        tooltipDisplayMode: _mode,
        tooltipSettings: InteractiveTooltip(format: 'point.x: point.y'),
        shouldAlwaysShow: showAlways ?? true,
      ),
    );
  }

  /// Returns the list of chart which need to render  on the cartesian chart.
  List<LineSeries<ChartSampleData, DateTime>> _getDefaultTrackballSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2000, 2, 11),
          y: 15,
          secondSeriesYValue: 39,
          thirdSeriesYValue: 60),
      ChartSampleData(
          x: DateTime(2000, 9, 14),
          y: 20,
          secondSeriesYValue: 30,
          thirdSeriesYValue: 55),
      ChartSampleData(
          x: DateTime(2001, 2, 11),
          y: 25,
          secondSeriesYValue: 28,
          thirdSeriesYValue: 48),
      ChartSampleData(
          x: DateTime(2001, 9, 16),
          y: 21,
          secondSeriesYValue: 35,
          thirdSeriesYValue: 57),
      ChartSampleData(
          x: DateTime(2002, 2, 7),
          y: 13,
          secondSeriesYValue: 39,
          thirdSeriesYValue: 62),
      ChartSampleData(
          x: DateTime(2002, 9, 7),
          y: 18,
          secondSeriesYValue: 41,
          thirdSeriesYValue: 64),
      ChartSampleData(
          x: DateTime(2003, 2, 11),
          y: 24,
          secondSeriesYValue: 45,
          thirdSeriesYValue: 57),
      ChartSampleData(
          x: DateTime(2003, 9, 14),
          y: 23,
          secondSeriesYValue: 48,
          thirdSeriesYValue: 53),
      ChartSampleData(
          x: DateTime(2004, 2, 6),
          y: 19,
          secondSeriesYValue: 54,
          thirdSeriesYValue: 63),
      ChartSampleData(
          x: DateTime(2004, 9, 6),
          y: 31,
          secondSeriesYValue: 55,
          thirdSeriesYValue: 50),
      ChartSampleData(
          x: DateTime(2005, 2, 11),
          y: 39,
          secondSeriesYValue: 57,
          thirdSeriesYValue: 66),
      ChartSampleData(
          x: DateTime(2005, 9, 11),
          y: 50,
          secondSeriesYValue: 60,
          thirdSeriesYValue: 65),
      ChartSampleData(
          x: DateTime(2006, 2, 11),
          y: 24,
          secondSeriesYValue: 60,
          thirdSeriesYValue: 79),
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
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
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
    setState(() {
      /// update the trackball display type changes
    });
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
    setState(() {
      /// update the tooltip alignment changes
    });
  }
}
