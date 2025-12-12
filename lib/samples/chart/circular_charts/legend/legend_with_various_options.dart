/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the Pie series chart with legend.
class LegendOptions extends SampleView {
  /// Creates the pie series chart with legend.
  const LegendOptions(Key key) : super(key: key);

  @override
  _LegendOptionsState createState() => _LegendOptionsState();
}

/// State class for the pie series chart with legend.
class _LegendOptionsState extends SampleViewState {
  _LegendOptionsState();
  late bool _toggleVisibility;
  late bool _enableFloatingLegend;
  late String _selectedPosition;
  late LegendPosition _position;
  late String _selectedMode;
  late LegendItemOverflowMode _overflowMode;
  late double _xOffset;
  late double _yOffset;
  late List<ChartSampleData> _chartData;

  List<String>? _positionList;
  List<String>? _modeList;

  @override
  void initState() {
    _xOffset = 0.0;
    _yOffset = 0.0;
    _overflowMode = LegendItemOverflowMode.wrap;
    _selectedMode = 'wrap';
    _position = LegendPosition.auto;
    _selectedPosition = 'auto';
    _toggleVisibility = true;
    _enableFloatingLegend = false;
    _positionList = <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
    _modeList = <String>['wrap', 'scroll', 'none'].toList();
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Tuition Fees', y: 21),
      ChartSampleData(x: 'Entertainment', y: 21),
      ChartSampleData(x: 'Private Gifts', y: 8),
      ChartSampleData(x: 'Local Revenue', y: 21),
      ChartSampleData(x: 'Federal Revenue', y: 16),
      ChartSampleData(x: 'Others', y: 8),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 14,
                  child: Column(
                    children: <Widget>[
                      _buildPositionDropdown(stateSetter),
                      _buildOverflowModeDropdown(stateSetter),
                      const SizedBox(height: 6.0),
                      _buildVisibilityToggle(stateSetter),
                      const SizedBox(height: 6.0),
                      _buildFloatingLegendToggle(stateSetter),
                      const SizedBox(height: 6.0),
                      _buildXOffsetControl(stateSetter),
                      _buildYOffsetControl(stateSetter),
                    ],
                  ),
                ),
                Expanded(flex: model.isMobile ? 5 : 1, child: Container()),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the dropdown for selecting the legend position.
  Widget _buildPositionDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'Position',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
            height: 50,
            width: 110,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              focusColor: Colors.transparent,
              isExpanded: true,
              underline: Container(color: const Color(0xFFBDBDBD), height: 1),
              value: _selectedPosition,
              items: _positionList!.map((String value) {
                return DropdownMenuItem<String>(
                  value: (value != null) ? value : 'auto',
                  child: Text(value, style: TextStyle(color: model.textColor)),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _updateLegendPosition(value.toString());
                stateSetter(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown for selecting the overflow mode of the legend.
  Widget _buildOverflowModeDropdown(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            model.isWebFullView ? 'Overflow \nmode' : 'Overflow mode',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
            height: 50,
            width: 110,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              focusColor: Colors.transparent,
              isExpanded: true,
              underline: Container(
                color: const Color.fromARGB(255, 70, 9, 9),
                height: 1,
              ),
              value: _selectedMode,
              items: _modeList!.map((String value) {
                return DropdownMenuItem<String>(
                  value: (value != null) ? value : 'wrap',
                  child: Text(value, style: TextStyle(color: model.textColor)),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _updateLegendOverflowMode(value);
                stateSetter(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the toggle for visibility of the legend.
  Widget _buildVisibilityToggle(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            model.isWebFullView ? 'Toggle \nvisibility' : 'Toggle visibility',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
            height: 50,
            alignment: Alignment.bottomLeft,
            child: Checkbox(
              activeColor: model.primaryColor,
              value: _toggleVisibility,
              onChanged: (bool? value) {
                setState(() {
                  _toggleVisibility = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the toggle for enabling/disabling floating legend.
  Widget _buildFloatingLegendToggle(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            model.isWebFullView ? 'Floating \nlegend' : 'Floating legend',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
            height: 50,
            alignment: Alignment.bottomLeft,
            child: Checkbox(
              activeColor: model.primaryColor,
              value: _enableFloatingLegend,
              onChanged: (bool? value) {
                setState(() {
                  _enableFloatingLegend = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the control for adjusting the X offset of the legend.
  Widget _buildXOffsetControl(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            'X offset',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        CustomDirectionalButtons(
          minValue: -100,
          maxValue: 100,
          initialValue: _xOffset,
          onChanged: (double val) => setState(() {
            _xOffset = _enableFloatingLegend ? val : 0;
          }),
          step: _enableFloatingLegend ? 10 : 0,
          iconColor: model.textColor.withValues(
            alpha: _enableFloatingLegend ? 1 : 0.5,
          ),
          style: TextStyle(
            fontSize: 16.0,
            color: model.textColor.withValues(
              alpha: _enableFloatingLegend ? 1 : 0.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the control for adjusting the Y offset of the legend.
  Widget _buildYOffsetControl(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            'Y offset',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        CustomDirectionalButtons(
          minValue: -100,
          maxValue: 100,
          initialValue: _yOffset,
          onChanged: (double val) => setState(() {
            _yOffset = _enableFloatingLegend ? val : 0;
          }),
          step: _enableFloatingLegend ? 10 : 0,
          iconColor: model.textColor.withValues(
            alpha: _enableFloatingLegend ? 1 : 0.5,
          ),
          style: TextStyle(
            fontSize: 16.0,
            color: model.textColor.withValues(
              alpha: _enableFloatingLegend ? 1 : 0.5,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendOptionsChart();
  }

  /// Return a circular pie chart which has legend with various options.
  SfCircularChart _buildLegendOptionsChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Expenses by category'),
      legend: Legend(
        isVisible: true,
        position: _position,
        offset: _enableFloatingLegend ? Offset(_xOffset, _yOffset) : null,
        overflowMode: _overflowMode,
        toggleSeriesVisibility: _toggleVisibility,
      ),
      series: _buildPiesSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPiesSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        startAngle: 90,
        endAngle: 90,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  /// Updates the selected legend position.
  void _updateLegendPosition(String item) {
    setState(() {
      _selectedPosition = item;
      if (_selectedPosition == 'auto') {
        _position = LegendPosition.auto;
      }
      if (_selectedPosition == 'bottom') {
        _position = LegendPosition.bottom;
      }
      if (_selectedPosition == 'right') {
        _position = LegendPosition.right;
      }
      if (_selectedPosition == 'left') {
        _position = LegendPosition.left;
      }
      if (_selectedPosition == 'top') {
        _position = LegendPosition.top;
      }
    });
  }

  /// Updates the selected legend overflow mode.
  void _updateLegendOverflowMode(String item) {
    setState(() {
      _selectedMode = item;
      if (_selectedMode == 'wrap') {
        _overflowMode = LegendItemOverflowMode.wrap;
      }
      if (_selectedMode == 'scroll') {
        _overflowMode = LegendItemOverflowMode.scroll;
      }
      if (_selectedMode == 'none') {
        _overflowMode = LegendItemOverflowMode.none;
      }
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _positionList!.clear();
    _modeList!.clear();
    super.dispose();
  }
}
