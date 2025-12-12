/// Package import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Chart import

/// Local import
import '../../model/sample_view.dart';
import '../../widgets/custom_button.dart';

/// Renders the sparkline custamization sample
class SparklineCustomization extends SampleView {
  /// Creates the sparkline custamization sample
  const SparklineCustomization(Key key) : super(key: key);

  @override
  _SparklineCustomizationState createState() => _SparklineCustomizationState();
}

class _SparklineCustomizationState extends SampleViewState {
  _SparklineCustomizationState();
  late double _axisCrossingValue, _startValue, _endValue;
  late List<String> _markerDisplayModeList;
  late String _selectedMarkerDisplayMode;
  late SparkChartMarkerDisplayMode _markerDisplayMode;
  late List<String> _datalabelDisplayModeList;
  late String _selectedDatalabelDisplayMode;
  late SparkChartLabelDisplayMode _dataLabelDisplayMode;
  late bool _enableTrackLine, _enablePlotband;

  @override
  void initState() {
    _axisCrossingValue = 0;
    _startValue = 0;
    _endValue = 0;
    _markerDisplayModeList = <String>[
      'none',
      'all',
      'high',
      'low',
      'first',
      'last',
    ].toList();
    _datalabelDisplayModeList = <String>[
      'none',
      'all',
      'high',
      'low',
      'first',
      'last',
    ].toList();
    _enableTrackLine = false;
    _dataLabelDisplayMode = SparkChartLabelDisplayMode.none;
    _enablePlotband = false;
    _selectedDatalabelDisplayMode = 'none';
    _selectedMarkerDisplayMode = 'none';
    _markerDisplayMode = SparkChartMarkerDisplayMode.none;
    _enableTrackLine = false;
    _enablePlotband = false;
    _axisCrossingValue = 0;
    _startValue = 2;
    _endValue = 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        width:
            model.isWebFullView ||
                MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.width / 2.5
            : MediaQuery.of(context).size.width / 1.2,
        child: _buildSparkBarCustomizationChart(),
      ),
    );
  }

  @override
  void dispose() {
    _markerDisplayModeList.clear();
    _datalabelDisplayModeList.clear();
    super.dispose();
  }

  SfSparkLineChart _buildSparkBarCustomizationChart() {
    return SfSparkLineChart(
      data: const <double>[
        1,
        5,
        -6,
        0,
        1,
        -2,
        7,
        -7,
        -4,
        -10,
        13,
        -6,
        7,
        5,
        11,
        5,
        3,
      ],
      labelDisplayMode: _dataLabelDisplayMode,
      axisCrossesAt: _axisCrossingValue,
      axisLineWidth: 1,
      axisLineColor: model.themeData.colorScheme.brightness == Brightness.dark
          ? const Color.fromRGBO(101, 101, 101, 1)
          : const Color.fromRGBO(181, 181, 181, 1),
      marker: SparkChartMarker(displayMode: _markerDisplayMode),
      plotBand: SparkChartPlotBand(
        start: _startValue,
        end: _endValue,
        color: _enablePlotband
            ? const Color.fromRGBO(191, 212, 252, 1)
            : Colors.transparent,
      ),
      trackball: _enableTrackLine ? const SparkChartTrackball() : null,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          padding: const EdgeInsets.only(right: 10),
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Marker',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedMarkerDisplayMode,
                  items: _markerDisplayModeList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'none',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    _onMarkerDisplayModeChange(value.toString());
                    stateSetter(() {});
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Data label',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedDatalabelDisplayMode,
                  items: _datalabelDisplayModeList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'none',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    _onDatalabelDisplayModeChange(value.toString());
                    stateSetter(() {});
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Trackball',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enableTrackLine,
                  onChanged: (bool? value) {
                    setState(() {
                      _enableTrackLine = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Axis value',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Row(
                  spacing: 2,
                  children: [
                    SizedBox(
                      width: 130,
                      child: SliderTheme(
                        data: SliderThemeData(
                          tickMarkShape: SliderTickMarkShape.noTickMark,
                        ),
                        child: Slider(
                          value: _axisCrossingValue,
                          min: -10,
                          max: 13,
                          divisions: 24,
                          onChanged: (double value) {
                            setState(() {
                              _axisCrossingValue = value;
                              stateSetter(() {});
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      '${_axisCrossingValue.floor()}',
                      style: TextStyle(color: model.textColor, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Plot band',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                Checkbox(
                  activeColor: model.primaryColor,
                  value: _enablePlotband,
                  onChanged: (bool? value) {
                    setState(() {
                      _enablePlotband = value!;
                      stateSetter(() {});
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: _enablePlotband,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: CustomDirectionalButtons(
                          maxValue: 13,
                          minValue: -10,
                          initialValue: _startValue,
                          onChanged: (double val) => setState(() {
                            _startValue = val;
                          }),
                          loop: true,
                          iconColor: model.textColor,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: model.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _enablePlotband,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'End',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.textColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: CustomDirectionalButtons(
                          maxValue: 13,
                          minValue: -10,
                          initialValue: _endValue,
                          onChanged: (double val) => setState(() {
                            _endValue = val;
                          }),
                          loop: true,
                          iconColor: model.textColor,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: model.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Method to change the marker display mode using dropdown menu.
  void _onMarkerDisplayModeChange(String item) {
    _selectedMarkerDisplayMode = item;
    if (_selectedMarkerDisplayMode == 'none') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.none;
    }
    if (_selectedMarkerDisplayMode == 'all') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.all;
    }
    if (_selectedMarkerDisplayMode == 'high') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.high;
    }
    if (_selectedMarkerDisplayMode == 'low') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.low;
    }
    if (_selectedMarkerDisplayMode == 'first') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.first;
    }
    if (_selectedMarkerDisplayMode == 'last') {
      _markerDisplayMode = SparkChartMarkerDisplayMode.last;
    }
    setState(() {
      /// update the marker display mode changes
    });
  }

  /// Method to change the data label display mode using dropdown menu.
  void _onDatalabelDisplayModeChange(String item) {
    _selectedDatalabelDisplayMode = item;
    if (_selectedDatalabelDisplayMode == 'none') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.none;
    }
    if (_selectedDatalabelDisplayMode == 'all') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.all;
    }
    if (_selectedDatalabelDisplayMode == 'high') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.high;
    }
    if (_selectedDatalabelDisplayMode == 'low') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.low;
    }
    if (_selectedDatalabelDisplayMode == 'first') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.first;
    }
    if (_selectedDatalabelDisplayMode == 'last') {
      _dataLabelDisplayMode = SparkChartLabelDisplayMode.last;
    }
    setState(() {
      /// update the data label display mode changes
    });
  }
}
