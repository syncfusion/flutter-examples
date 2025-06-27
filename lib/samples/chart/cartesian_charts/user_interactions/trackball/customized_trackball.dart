/// Package import.
import 'dart:math';
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked line series chart with custom trackball.
class TrackballBuilder extends SampleView {
  /// Creates the stacked line series chart with custom trackball.
  const TrackballBuilder(Key key) : super(key: key);

  @override
  _TrackballBuilderState createState() => _TrackballBuilderState();
}

/// State class for the stacked line series chart with custom trackball.
class _TrackballBuilderState extends SampleViewState {
  _TrackballBuilderState();
  late TrackballDisplayMode _trackballDisplayMode;
  late List<String> _trackballDisplayModeList;
  late List<ChartSampleData> _chartData;
  late String _selectedMode;
  late bool _isBuilder;
  late bool _enableTrackball1;
  late bool _enableTrackball2;
  late bool _enableTrackball3;
  late bool _enableTrackball4;

  @override
  void initState() {
    _trackballDisplayModeList = <String>[
      'floatAllPoints',
      'groupAllPoints',
      'nearestPoint',
    ].toList();
    _selectedMode = 'floatAllPoints';
    _trackballDisplayMode = TrackballDisplayMode.floatAllPoints;
    _isBuilder = true;
    _enableTrackball1 = true;
    _enableTrackball2 = true;
    _enableTrackball3 = true;
    _enableTrackball4 = true;
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Food',
        y: 55,
        yValue: 40,
        secondSeriesYValue: 45,
        thirdSeriesYValue: 48,
      ),
      ChartSampleData(
        x: 'Transport',
        y: 33,
        yValue: 45,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 28,
      ),
      ChartSampleData(
        x: 'Medical',
        y: 43,
        yValue: 23,
        secondSeriesYValue: 20,
        thirdSeriesYValue: 34,
      ),
      ChartSampleData(
        x: 'Clothes',
        y: 32,
        yValue: 54,
        secondSeriesYValue: 23,
        thirdSeriesYValue: 54,
      ),
      ChartSampleData(
        x: 'Books',
        y: 56,
        yValue: 18,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 55,
      ),
      ChartSampleData(
        x: 'Others',
        y: 23,
        yValue: 54,
        secondSeriesYValue: 33,
        thirdSeriesYValue: 56,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackballBuilderChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildDisplayModeSetting(stateSetter),
            _buildTooltipBuilderSetting(stateSetter),
            const SizedBox(height: 12.0),
            Text(
              'Enable Trackball',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Text(
                        'John',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enableTrackball1,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableTrackball1 = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Mary',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enableTrackball2,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableTrackball2 = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Martin',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enableTrackball3,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableTrackball3 = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Text(
                        'Jessica',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enableTrackball4,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableTrackball4 = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the display mode setting section.
  Widget _buildDisplayModeSetting(StateSetter stateSetter) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: [
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  Text(
                    'Mode',
                    style: TextStyle(color: model.textColor, fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: 145,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                isExpanded: true,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedMode,
                items: _trackballDisplayModeList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'floatAllPoints',
                    child: Text(
                      value,
                      style: TextStyle(color: model.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _updateTrackballDisplayMode(value!);
                    stateSetter(() {});
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the tooltip builder setting section.
  Widget _buildTooltipBuilderSetting(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Row(
            children: [
              Text(
                'Tooltip \nbuilder',
                softWrap: false,
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
            ],
          ),
        ),
        Checkbox(
          activeColor: model.primaryColor,
          value: _isBuilder,
          onChanged: (bool? value) {
            setState(() {
              _isBuilder = value!;
              stateSetter(() {});
            });
          },
        ),
      ],
    );
  }

  /// Returns the cartesian stacked line chart with custom trackball.
  SfCartesianChart _buildTrackballBuilderChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Monthly expense of a family'),
      legend: Legend(isVisible: !isCardView, toggleSeriesVisibility: false),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelRotation: isCardView || model.isWebFullView ? 0 : -45,
      ),
      primaryYAxis: const NumericAxis(
        maximum: 200,
        axisLine: AxisLine(width: 0),
        labelFormat: r'${value}',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedLineSeries(),

      /// To set the trackball as true and customized trackball behavior.
      trackballBehavior: TrackballBehavior(
        enable: true,
        hideDelay: 2000,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
          height: 10,
          width: 10,
          borderWidth: 1,
        ),
        tooltipDisplayMode: isCardView
            ? TrackballDisplayMode.floatAllPoints
            : _trackballDisplayMode,
        builder: _isBuilder
            ? (BuildContext context, TrackballDetails trackballDetails) {
                final TextStyle textStyle = _buildTrackballTextStyle();
                double imageWidth = 0.0;
                double imageHeight = 0.0;
                double width = 0.0;
                double height = 0.0;
                if (_trackballDisplayMode ==
                    TrackballDisplayMode.groupAllPoints) {
                  height = 1.0; // Divider width.
                  imageWidth = 40;
                  imageHeight = 40;
                  final String header = trackballDetails
                      .groupingModeInfo!
                      .points[0]
                      .x
                      .toString();
                  final Size headerSize = measureText(header, textStyle);
                  width = max(width, headerSize.width);
                  height += headerSize.height;
                  final int length = trackballDetails
                      .groupingModeInfo!
                      .visibleSeriesIndices
                      .length;
                  for (int i = 0; i < length; i++) {
                    final String text =
                        '${trackballDetails.groupingModeInfo!.visibleSeriesList[i].name} : \$${trackballDetails.groupingModeInfo!.points[i].y}';
                    final Size size = measureText(text, textStyle);
                    width = max(width, size.width);
                    height += size.height;
                  }
                  width = max(width, 80);
                  width += imageWidth + 25;
                  height += imageHeight;
                } else {
                  imageWidth = 35;
                  imageHeight = 35;
                  final String xText = trackballDetails.point!.x.toString();
                  final String yText = '\$${trackballDetails.point!.y}';
                  final Size xTextSize = measureText(xText, textStyle);
                  final Size yTextSize = measureText(yText, textStyle);
                  width = imageWidth + 5 + xTextSize.width + yTextSize.width;
                  final double maxHeight = max(
                    xTextSize.height,
                    yTextSize.height,
                  );
                  height = imageHeight + maxHeight;
                }

                return Container(
                  padding: const EdgeInsets.all(5.0),
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.dark
                        ? const Color.fromRGBO(255, 255, 255, 1)
                        : const Color.fromRGBO(0, 8, 22, 0.75),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: Image.asset(
                              _buildImageBuilder(trackballDetails),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: _buildGroupingBuilderWidgets(
                              trackballDetails,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            : null,
      ),
    );
  }

  /// Builds the widgets for grouping mode in the trackball.
  Column _buildGroupingBuilderWidgets(TrackballDetails trackballDetails) {
    final List<Widget> widgets = <Widget>[];
    if (_trackballDisplayMode == TrackballDisplayMode.groupAllPoints) {
      _addGroupAllPointsWidgets(trackballDetails, widgets);
    } else {
      _addSinglePointWidgets(trackballDetails, widgets);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  /// Adds widgets for the group all points mode.
  void _addGroupAllPointsWidgets(
    TrackballDetails trackballDetails,
    List<Widget> widgets,
  ) {
    widgets.add(
      Padding(
        padding: EdgeInsets.zero,
        child: Text(
          trackballDetails.groupingModeInfo!.points[0].x.toString(),
          style: TextStyle(
            color: model.themeData.colorScheme.brightness == Brightness.dark
                ? const Color.fromRGBO(0, 0, 0, 1)
                : const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
    );
    widgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Container(
          height: 1,
          width: 80,
          color: model.themeData.colorScheme.brightness == Brightness.dark
              ? const Color.fromRGBO(61, 61, 61, 1)
              : const Color.fromRGBO(238, 238, 238, 1),
        ),
      ),
    );

    final List<Widget> innerWidgets = <Widget>[];
    final int length =
        trackballDetails.groupingModeInfo!.visibleSeriesIndices.length;
    for (int i = 0; i < length; i++) {
      innerWidgets.add(
        Text(
          '${trackballDetails.groupingModeInfo!.visibleSeriesList[i].name} : \$${trackballDetails.groupingModeInfo!.points[i].y}',
          textAlign: TextAlign.left,
          style: _buildTrackballTextStyle(),
        ),
      );
    }

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: innerWidgets,
      ),
    );
  }

  /// Adds widgets for the single point mode.
  void _addSinglePointWidgets(
    TrackballDetails trackballDetails,
    List<Widget> widgets,
  ) {
    widgets.add(
      Text(
        trackballDetails.point!.x.toString(),
        style: _buildTrackballTextStyle(),
      ),
    );
    widgets.add(
      Text(
        '\$${trackballDetails.point!.y}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: model.themeData.colorScheme.brightness == Brightness.dark
              ? const Color.fromRGBO(0, 0, 0, 1)
              : const Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
    );
  }

  TextStyle _buildTrackballTextStyle() {
    return TextStyle(
      color: model.themeData.colorScheme.brightness == Brightness.dark
          ? const Color.fromRGBO(0, 0, 0, 1)
          : const Color.fromRGBO(255, 255, 255, 1),
    );
  }

  /// Returns the list of cartesian stacked line series.
  List<CartesianSeries<ChartSampleData, String>> _buildStackedLineSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'John',
        enableTrackball: _enableTrackball1,
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Mary',
        enableTrackball: _enableTrackball2,
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Martin',
        enableTrackball: _enableTrackball3,
      ),
      StackedLineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Jessica',
        enableTrackball: _enableTrackball4,
      ),
    ];
  }

  String _buildImageBuilder(TrackballDetails pointInfo) {
    final int? seriesIndex = pointInfo.seriesIndex;
    return seriesIndex == 0
        ? 'images/People_Circle12.png'
        : seriesIndex == 1
        ? 'images/People_Circle3.png'
        : seriesIndex == 2
        ? 'images/People_Circle14.png'
        : seriesIndex == 3
        ? 'images/People_Circle16.png'
        : model.themeData.colorScheme.brightness == Brightness.dark
        ? 'images/grouping_dark.png'
        : 'images/grouping_light.png';
  }

  /// Method to update the trackball display mode in the chart on change.
  void _updateTrackballDisplayMode(String item) {
    _selectedMode = item;
    if (_selectedMode == 'floatAllPoints') {
      _trackballDisplayMode = TrackballDisplayMode.floatAllPoints;
    }
    if (_selectedMode == 'groupAllPoints') {
      _trackballDisplayMode = TrackballDisplayMode.groupAllPoints;
    }
    if (_selectedMode == 'nearestPoint') {
      _trackballDisplayMode = TrackballDisplayMode.nearestPoint;
    }
    if (_selectedMode == 'none') {
      _trackballDisplayMode = TrackballDisplayMode.none;
    }
    setState(() {
      /// Update the trackball display type changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _trackballDisplayModeList.clear();
    super.dispose();
  }
}
