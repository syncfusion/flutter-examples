/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the Pie chart with legend
class LegendOptions extends SampleView {
  /// Creates the doughnut chart with legend
  const LegendOptions(Key key) : super(key: key);

  @override
  _LegendOptionsState createState() => _LegendOptionsState();
}

class _LegendOptionsState extends SampleViewState {
  _LegendOptionsState();
  late bool toggleVisibility;
  late bool enableFloatingLegend;
  List<String>? _positionList;
  List<String>? _modeList;
  late String _selectedPosition;
  late LegendPosition _position;

  late String _selectedMode;
  late LegendItemOverflowMode _overflowMode;
  late double _xOffset;
  late double _yOffset;

  @override
  void initState() {
    _xOffset = 0.0;
    _yOffset = 0.0;
    _overflowMode = LegendItemOverflowMode.wrap;
    _selectedMode = 'wrap';
    _position = LegendPosition.auto;
    _selectedPosition = 'auto';
    toggleVisibility = true;
    enableFloatingLegend = false;
    _positionList = <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
    _modeList = <String>['wrap', 'scroll', 'none'].toList();
    super.initState();
  }

  @override
  void dispose() {
    _positionList!.clear();
    _modeList!.clear();
    super.dispose();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.7 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
              Expanded(
                flex: 14,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('Position',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<String>(
                                  focusColor: Colors.transparent,
                                  isExpanded: true,
                                  underline: Container(
                                      color: const Color(0xFFBDBDBD),
                                      height: 1),
                                  value: _selectedPosition,
                                  items: _positionList!.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: (value != null) ? value : 'auto',
                                        child: Text(value,
                                            style: TextStyle(
                                                color: model.textColor)));
                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    _onPositionTypeChange(value.toString());
                                    stateSetter(() {});
                                  })),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                              model.isWebFullView
                                  ? 'Overflow \nmode'
                                  : 'Overflow mode',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: dropDownWidth,
                            child: DropdownButton<String>(
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                    color: const Color(0xFFBDBDBD), height: 1),
                                value: _selectedMode,
                                items: _modeList!.map((String value) {
                                  return DropdownMenuItem<String>(
                                      value: (value != null) ? value : 'wrap',
                                      child: Text(value,
                                          style: TextStyle(
                                              color: model.textColor)));
                                }).toList(),
                                onChanged: (dynamic value) {
                                  _onModeTypeChange(value);
                                  stateSetter(() {});
                                }),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                              model.isWebFullView
                                  ? 'Toggle \nvisibility'
                                  : 'Toggle visibility',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: model.isMobile
                                      ? 0.29 * screenWidth
                                      : 0.37 * screenWidth),
                              width: dropDownWidth,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: toggleVisibility,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      toggleVisibility = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        )
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                              model.isWebFullView
                                  ? 'Floating \nlegend'
                                  : 'Floating legend',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: model.isMobile
                                      ? 0.29 * screenWidth
                                      : 0.37 * screenWidth),
                              width: dropDownWidth,
                              child: Checkbox(
                                  activeColor: model.backgroundColor,
                                  value: enableFloatingLegend,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      enableFloatingLegend = value!;
                                      stateSetter(() {});
                                    });
                                  })),
                        )
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text('X offset',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          flex: 4,
                          child: CustomDirectionalButtons(
                            minValue: -100,
                            maxValue: 100,
                            initialValue: _xOffset,
                            onChanged: (double val) => setState(() {
                              _xOffset = enableFloatingLegend ? val : 0;
                            }),
                            step: enableFloatingLegend ? 10 : 0,
                            iconColor: model.textColor
                                .withOpacity(enableFloatingLegend ? 1 : 0.5),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: model.textColor.withOpacity(
                                    enableFloatingLegend ? 1 : 0.5)),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text('Y offset',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          flex: 4,
                          child: CustomDirectionalButtons(
                            minValue: -100,
                            maxValue: 100,
                            initialValue: _yOffset,
                            onChanged: (double val) => setState(() {
                              _yOffset = enableFloatingLegend ? val : 0;
                            }),
                            step: enableFloatingLegend ? 10 : 0,
                            iconColor: model.textColor
                                .withOpacity(enableFloatingLegend ? 1 : 0.5),
                            style: TextStyle(
                                fontSize: 16.0,
                                color: model.textColor.withOpacity(
                                    enableFloatingLegend ? 1 : 0.5)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
            ],
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLegendOptionsChart();
  }

  ///Get the circular chart which has legend
  SfCircularChart _buildLegendOptionsChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Expenses by category'),
      legend: Legend(
          isVisible: true,
          position: _position,
          offset: enableFloatingLegend ? Offset(_xOffset, _yOffset) : null,
          overflowMode: _overflowMode,
          toggleSeriesVisibility: toggleVisibility),
      series: _getLegendOptionsSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  ///Get the pie series
  List<PieSeries<ChartSampleData, String>> _getLegendOptionsSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Tution Fees', y: 21),
            ChartSampleData(x: 'Entertainment', y: 21),
            ChartSampleData(x: 'Private Gifts', y: 8),
            ChartSampleData(x: 'Local Revenue', y: 21),
            ChartSampleData(x: 'Federal Revenue', y: 16),
            ChartSampleData(x: 'Others', y: 8)
          ],
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }

  ///Changing the legend position
  void _onPositionTypeChange(String item) {
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

  ///Change the legend overflow mode
  void _onModeTypeChange(String item) {
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
}
