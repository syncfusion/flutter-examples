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
  double _axisCrossingValue = 0, _startValue = 0, _endValue = 0;
  final List<String> _markerDisplayModeList =
      <String>['none', 'all', 'high', 'low', 'first', 'last'].toList();
  String _selectedMarkerDisplayMode = 'none';
  SparkChartMarkerDisplayMode _markerDisplayMode =
      SparkChartMarkerDisplayMode.none;
  final List<String> _datalabelDisplayModeList =
      <String>['none', 'all', 'high', 'low', 'first', 'last'].toList();
  String _selectedDatalabelDisplayMode = 'none';
  SparkChartLabelDisplayMode _dataLabelDisplayMode =
      SparkChartLabelDisplayMode.none;
  bool _enableTrackLine = false, _enablePlotband = false;

  @override
  void initState() {
    _selectedDatalabelDisplayMode = 'none';
    _dataLabelDisplayMode = SparkChartLabelDisplayMode.none;
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
        child: Container(
      height: MediaQuery.of(context).size.height / 3,
      width: model.isWebFullView ||
              MediaQuery.of(context).orientation == Orientation.landscape
          ? MediaQuery.of(context).size.width / 2.5
          : MediaQuery.of(context).size.width / 1.2,
      child: _buildSparkBarCustomizationChart(),
    ));
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
        3
      ],
      labelDisplayMode: _dataLabelDisplayMode,
      axisCrossesAt: _axisCrossingValue,
      axisLineWidth: 1,
      axisLineColor: model.themeData.brightness == Brightness.dark
          ? const Color.fromRGBO(101, 101, 101, 1)
          : const Color.fromRGBO(181, 181, 181, 1),
      marker: SparkChartMarker(borderWidth: 2, displayMode: _markerDisplayMode),
      plotBand: SparkChartPlotBand(
          start: _startValue,
          end: _endValue,
          color: _enablePlotband
              ? const Color.fromRGBO(191, 212, 252, 1)
              : Colors.transparent),
      trackball: _enableTrackLine
          ? const SparkChartTrackball(
              activationMode: SparkChartActivationMode.tap)
          : null,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: !model.isWebFullView,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text('Marker',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(75, 0, 0, 0)),
                Container(
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedMarkerDisplayMode,
                      items: _markerDisplayModeList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'none',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (String? value) {
                        _onMarkerDisplayModeChange(value.toString());
                        stateSetter(() {});
                      }),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Data label',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(55, 0, 0, 0)),
                Container(
                  height: 50,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                      underline:
                          Container(color: const Color(0xFFBDBDBD), height: 1),
                      value: _selectedDatalabelDisplayMode,
                      items: _datalabelDisplayModeList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'none',
                            child: Text(value,
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (String? value) {
                        _onDatalabelDisplayModeChange(value.toString());
                        stateSetter(() {});
                      }),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Trackball',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(16, 0, 0, 0)),
                Container(
                    width: 90,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: _enableTrackLine,
                        onChanged: (bool? value) {
                          setState(() {
                            _enableTrackLine = value!;
                            stateSetter(() {});
                          });
                        }))
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Axis value',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                const Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
                Container(
                    width: 150,
                    child: SliderTheme(
                        data: SliderThemeData(
                            tickMarkShape: SliderTickMarkShape.noTickMark),
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
                        ))),
                const Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
                Container(
                  child: Text('${_axisCrossingValue.floor()}',
                      style: TextStyle(
                        color: model.textColor,
                        fontSize: 16,
                      )),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Plot band',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                    width: 90,
                    child: CheckboxListTile(
                        activeColor: model.backgroundColor,
                        value: _enablePlotband,
                        onChanged: (bool? value) {
                          setState(() {
                            _enablePlotband = value!;
                            stateSetter(() {});
                          });
                        }))
              ],
            ),
          ),
          Visibility(
              visible: _enablePlotband,
              child: Row(children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Start',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      ),
                    ]),
                const Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          style:
                              TextStyle(fontSize: 20.0, color: model.textColor),
                        ),
                      )
                    ]),
              ])),
          Visibility(
              visible: _enablePlotband,
              child: Row(children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'End',
                        style:
                            TextStyle(fontSize: 16.0, color: model.textColor),
                      )
                    ]),
                const Padding(padding: EdgeInsets.fromLTRB(25, 0, 0, 0)),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          style:
                              TextStyle(fontSize: 20.0, color: model.textColor),
                        ),
                      )
                    ]),
              ])),
        ],
      );
    });
  }

  /// Method to change the marker display mode using dropdown menu.
  void _onMarkerDisplayModeChange(String _item) {
    _selectedMarkerDisplayMode = _item;
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
  void _onDatalabelDisplayModeChange(String _item) {
    _selectedDatalabelDisplayMode = _item;
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
