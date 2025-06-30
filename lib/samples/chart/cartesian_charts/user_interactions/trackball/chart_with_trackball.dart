/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the line series chart with default trackball.
class DefaultTrackball extends SampleView {
  /// Creates the line series chart with default trackball.
  const DefaultTrackball(Key key) : super(key: key);

  @override
  _DefaultTrackballState createState() => _DefaultTrackballState();
}

/// State class for the line series chart with default trackball.
class _DefaultTrackballState extends SampleViewState {
  _DefaultTrackballState();
  late double _hideDelayDuration;
  late bool _shouldAlwaysShow;
  late bool _canShowMarker;
  late List<String> _trackballModes;
  late String _selectedMode;
  late TrackballDisplayMode _trackballDisplayMode;
  late List<String> _alignmentList;
  late String _tooltipAlignment;
  late bool _showMarker;
  late ChartAlignment _tooltipAlignmentSetting;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _trackballModes = <String>[
      'floatAllPoints',
      'groupAllPoints',
      'nearestPoint',
    ].toList();
    _alignmentList = <String>['center', 'far', 'near'].toList();
    _hideDelayDuration = 2;
    _shouldAlwaysShow = false;
    _canShowMarker = true;
    _selectedMode = 'floatAllPoints';
    _trackballDisplayMode = TrackballDisplayMode.floatAllPoints;
    _tooltipAlignment = 'center';
    _showMarker = true;
    _tooltipAlignmentSetting = ChartAlignment.center;
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(
        x: DateTime(2000, 2, 11),
        y: 15,
        secondSeriesYValue: 39,
        thirdSeriesYValue: 60,
      ),
      ChartSampleData(
        x: DateTime(2000, 9, 14),
        y: 20,
        secondSeriesYValue: 30,
        thirdSeriesYValue: 55,
      ),
      ChartSampleData(
        x: DateTime(2001, 2, 11),
        y: 25,
        secondSeriesYValue: 28,
        thirdSeriesYValue: 48,
      ),
      ChartSampleData(
        x: DateTime(2001, 9, 16),
        y: 21,
        secondSeriesYValue: 35,
        thirdSeriesYValue: 57,
      ),
      ChartSampleData(
        x: DateTime(2002, 2, 7),
        y: 13,
        secondSeriesYValue: 39,
        thirdSeriesYValue: 62,
      ),
      ChartSampleData(
        x: DateTime(2002, 9, 7),
        y: 18,
        secondSeriesYValue: 41,
        thirdSeriesYValue: 64,
      ),
      ChartSampleData(
        x: DateTime(2003, 2, 11),
        y: 24,
        secondSeriesYValue: 45,
        thirdSeriesYValue: 57,
      ),
      ChartSampleData(
        x: DateTime(2003, 9, 14),
        y: 23,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 53,
      ),
      ChartSampleData(
        x: DateTime(2004, 2, 6),
        y: 19,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 63,
      ),
      ChartSampleData(
        x: DateTime(2004, 9, 6),
        y: 31,
        secondSeriesYValue: 55,
        thirdSeriesYValue: 50,
      ),
      ChartSampleData(
        x: DateTime(2005, 2, 11),
        y: 39,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: DateTime(2005, 9, 11),
        y: 50,
        secondSeriesYValue: 60,
        thirdSeriesYValue: 65,
      ),
      ChartSampleData(
        x: DateTime(2006, 2, 11),
        y: 24,
        secondSeriesYValue: 60,
        thirdSeriesYValue: 79,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultTrackballChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildModeAndAlignment(stateSetter),
            _buildCheckboxesAndControls(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the mode selection and alignment dropdowns.
  Widget _buildModeAndAlignment(StateSetter stateSetter) {
    return SizedBox(
      height: 110,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text(
                'Mode',
                softWrap: false,
                style: TextStyle(fontSize: 16, color: model.textColor),
              ),
              Container(
                height: 50,
                padding: !model.isWebFullView
                    ? const EdgeInsets.fromLTRB(90, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(55, 0, 0, 0),
                child: DropdownButton<String>(
                  dropdownColor: model.drawerBackgroundColor,
                  focusColor: Colors.transparent,
                  underline: Container(
                    color: const Color(0xFFBDBDBD),
                    height: 1,
                  ),
                  value: _selectedMode,
                  items: _trackballModes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'point',
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      _updateTrackballDisplayMode(value);
                      stateSetter(() {});
                    });
                  },
                ),
              ),
            ],
          ),
          _buildAlignmentDropdown(stateSetter),
        ],
      ),
    );
  }

  /// Builds the alignment dropdown based on the selected mode.
  Widget _buildAlignmentDropdown(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            'Alignment',
            softWrap: false,
            style: TextStyle(
              fontSize: 16,
              color: _selectedMode != 'groupAllPoints'
                  ? model.textColor.withValues(alpha: 0.3)
                  : model.textColor,
            ),
          ),
        ),
        Container(
          height: 50,
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(60, 0, 0, 0)
              : const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _tooltipAlignment,
            items: _selectedMode != 'groupAllPoints'
                ? null
                : _alignmentList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'center',
                      child: Text(
                        value,
                        style: TextStyle(color: model.textColor),
                      ),
                    );
                  }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _onAlignmentChange(value);
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the checkboxes and controls for show/hide options.
  Widget _buildCheckboxesAndControls(StateSetter stateSetter) {
    return Column(
      children: <Widget>[
        _buildShowAlwaysCheckbox(stateSetter),
        _buildHideDelayControl(stateSetter),
        _buildShowTrackMarkerCheckbox(stateSetter),
        _buildShowMarkerInTooltipCheckbox(stateSetter),
      ],
    );
  }

  /// Builds the checkbox for showing always.
  Widget _buildShowAlwaysCheckbox(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            model.isWebFullView ? 'Show \nalways ' : 'Show always',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Container(
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(25, 0, 0, 0)
              : const EdgeInsets.fromLTRB(42, 0, 0, 0),
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

  /// Builds the control for hide delay.
  Widget _buildHideDelayControl(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            model.isWebFullView ? 'Hide \ndelay  ' : 'Hide delay  ',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Container(
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(32, 0, 0, 0)
              : const EdgeInsets.fromLTRB(38, 0, 0, 0),
          child: CustomDirectionalButtons(
            maxValue: 10,
            initialValue: _hideDelayDuration,
            onChanged: (double value) => setState(() {
              _hideDelayDuration = value;
            }),
            step: 2,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the checkbox for showing track marker.
  Widget _buildShowTrackMarkerCheckbox(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            model.isWebFullView ? 'Show \ntrack\nmarker' : 'Show track\nmarker',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Container(
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(40, 0, 0, 0)
              : const EdgeInsets.fromLTRB(42, 0, 0, 0),
          child: Checkbox(
            activeColor: model.primaryColor,
            value: _showMarker,
            onChanged: (bool? value) {
              setState(() {
                _showMarker = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the checkbox for showing marker in tooltip.
  Widget _buildShowMarkerInTooltipCheckbox(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            model.isWebFullView
                ? 'Show \nmarker\nin \ntooltip'
                : 'Show marker\nin tooltip',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Container(
          padding: !model.isWebFullView
              ? const EdgeInsets.fromLTRB(25, 0, 0, 0)
              : const EdgeInsets.fromLTRB(42, 0, 0, 0),
          child: Checkbox(
            activeColor: model.primaryColor,
            value: _canShowMarker,
            onChanged: (bool? value) {
              setState(() {
                _canShowMarker = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian line chart with default trackball.
  SfCartesianChart _buildDefaultTrackballChart() {
    return SfCartesianChart(
      title: ChartTitle(text: !isCardView ? 'Average sales per person' : ''),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        interval: 1,
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: !isCardView ? 'Revenue' : ''),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
      ),
      series: _buildLineSeries(),

      /// To set the track ball as true
      /// and customized trackball behavior.
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
        hideDelay: _hideDelayDuration * 1000,
        activationMode: ActivationMode.singleTap,
        tooltipAlignment: _tooltipAlignmentSetting,
        tooltipDisplayMode: _trackballDisplayMode,
        tooltipSettings: InteractiveTooltip(
          format: _trackballDisplayMode != TrackballDisplayMode.groupAllPoints
              ? 'series.name : point.y'
              : null,
          canShowMarker: _canShowMarker,
        ),
        shouldAlwaysShow: _shouldAlwaysShow,
      ),
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'John',
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Andrew',
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Thomas',
      ),
    ];
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

  /// Method to update the chart alignment for tooltip in the chart on change.
  void _onAlignmentChange(String item) {
    _tooltipAlignment = item;
    if (_tooltipAlignment == 'center') {
      _tooltipAlignmentSetting = ChartAlignment.center;
    }
    if (_tooltipAlignment == 'far') {
      _tooltipAlignmentSetting = ChartAlignment.far;
    }
    if (_tooltipAlignment == 'near') {
      _tooltipAlignmentSetting = ChartAlignment.near;
    }
    setState(() {
      /// Update the tooltip alignment changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _alignmentList.clear();
    _trackballModes.clear();
    super.dispose();
  }
}
