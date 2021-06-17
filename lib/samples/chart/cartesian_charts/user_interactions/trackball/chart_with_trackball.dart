/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

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
  late double duration;
  late bool showAlways;
  late bool canShowMarker;
  final List<String> _modeList =
      <String>['floatAllPoints', 'groupAllPoints', 'nearestPoint'].toList();
  late String _selectedMode;

  late TrackballDisplayMode _mode;

  final List<String> _alignmentList =
      <String>['center', 'far', 'near'].toList();
  late String _tooltipAlignment;
  late bool _showMarker;
  ChartAlignment _alignment = ChartAlignment.center;

  @override
  void initState() {
    duration = 2;
    showAlways = false;
    canShowMarker = true;
    _selectedMode = 'floatAllPoints';
    _mode = TrackballDisplayMode.floatAllPoints;
    _tooltipAlignment = 'center';
    _showMarker = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultTrackballChart();
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
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 110,
                child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      ListTile(
                        title: Text('Mode',
                            style: TextStyle(
                              color: model.textColor,
                            )),
                        trailing: Container(
                          padding: EdgeInsets.only(left: 0.07 * screenWidth),
                          width: 0.6 * screenWidth,
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          child: DropdownButton<String>(
                              underline: Container(
                                  color: const Color(0xFFBDBDBD), height: 1),
                              value: _selectedMode,
                              items: _modeList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'point',
                                    child: Text(value,
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  onModeTypeChange(value);
                                  stateSetter(() {});
                                });
                              }),
                        ),
                      ),
                      ListTile(
                        title: Text('Alignment',
                            style: TextStyle(
                              color: _selectedMode != 'groupAllPoints'
                                  ? model.textColor.withOpacity(0.3)
                                  : model.textColor,
                            )),
                        trailing: Container(
                            padding: EdgeInsets.only(left: 0.07 * screenWidth),
                            width: 0.6 * screenWidth,
                            height: 50,
                            alignment: Alignment.bottomLeft,
                            child: DropdownButton<String>(
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _tooltipAlignment,
                                items: _selectedMode != 'groupAllPoints'
                                    ? null
                                    : _alignmentList.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: (value != null)
                                                ? value
                                                : 'center',
                                            child: Text(value,
                                                style: TextStyle(
                                                    color: model.textColor)));
                                      }).toList(),
                                onChanged: (dynamic value) {
                                  onAlignmentChange(value);
                                  stateSetter(() {});
                                })),
                      )
                    ]));
          }),
          ListTile(
              title: Text('Show always ',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                  padding: EdgeInsets.only(left: 0.05 * screenWidth),
                  width: 0.6 * screenWidth,
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: model.backgroundColor,
                      value: showAlways,
                      onChanged: (bool? value) {
                        setState(() {
                          showAlways = value!;
                          stateSetter(() {});
                        });
                      }))),
          ListTile(
            title:
                Text('Hide delay  ', style: TextStyle(color: model.textColor)),
            trailing: Container(
              width: 0.6 * screenWidth,
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
          ListTile(
            title: Text('Show track\nmarker',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth),
                width: 0.6 * screenWidth,
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.backgroundColor,
                    value: _showMarker,
                    onChanged: (bool? value) {
                      setState(() {
                        _showMarker = value!;
                        stateSetter(() {});
                      });
                    })),
          ),
          ListTile(
            title: Text('Show marker\nin tooltip',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth),
                width: 0.6 * screenWidth,
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.backgroundColor,
                    value: canShowMarker,
                    onChanged: (bool? value) {
                      setState(() {
                        canShowMarker = value!;
                        stateSetter(() {});
                      });
                    })),
          ),
        ],
      );
    });
  }

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart _buildDefaultTrackballChart() {
    return SfCartesianChart(
      title: ChartTitle(text: !isCardView ? 'Average sales per person' : ''),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          interval: 1,
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: !isCardView ? 'Revenue' : ''),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0)),
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
        hideDelay: duration * 1000,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _alignment,
        tooltipDisplayMode: _mode,
        tooltipSettings: InteractiveTooltip(
            format: _mode != TrackballDisplayMode.groupAllPoints
                ? 'series.name : point.y'
                : null,
            canShowMarker: canShowMarker),
        shouldAlwaysShow: showAlways,
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
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2,
          name: 'John',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          width: 2,
          name: 'Andrew',
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          width: 2,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: 'Thomas',
          markerSettings: const MarkerSettings(isVisible: true))
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
