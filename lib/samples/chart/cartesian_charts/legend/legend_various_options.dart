/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

// Renders the StackedArea Chart and legend with various options sample.
class CartesianLegendOptions extends SampleView {
  const CartesianLegendOptions(Key key) : super(key: key);

  @override
  _CartesianLegendOptionsState createState() => _CartesianLegendOptionsState();
}

/// State class of the Cartesian legend with various options sample.
class _CartesianLegendOptionsState extends SampleViewState {
  _CartesianLegendOptionsState();

  late double _xOffset;
  late double _yOffset;
  late String _selectedPosition;
  LegendPosition? _position;
  late String _selectedMode;
  LegendItemOverflowMode? _overflowMode;
  late bool _toggleVisibility;
  late bool _enableFloatingLegend;
  List<String>? _positionList;
  List<String>? _modeList;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _fruitsSalesComparisonData;

  @override
  void initState() {
    _xOffset = 0.0;
    _yOffset = 0.0;
    _selectedPosition = 'auto';
    _position = LegendPosition.auto;
    _selectedMode = 'wrap';
    _overflowMode = LegendItemOverflowMode.wrap;
    _toggleVisibility = true;
    _enableFloatingLegend = false;
    _positionList = <String>['auto', 'bottom', 'left', 'right', 'top'].toList();
    _modeList = <String>['wrap', 'scroll', 'none'].toList();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _fruitsSalesComparisonData = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2000),
        y: 0.61,
        yValue: 0.03,
        secondSeriesYValue: 0.48,
        thirdSeriesYValue: 0.23,
      ),
      ChartSampleData(
        x: DateTime(2001),
        y: 0.81,
        yValue: 0.05,
        secondSeriesYValue: 0.53,
        thirdSeriesYValue: 0.17,
      ),
      ChartSampleData(
        x: DateTime(2002),
        y: 0.91,
        yValue: 0.06,
        secondSeriesYValue: 0.57,
        thirdSeriesYValue: 0.17,
      ),
      ChartSampleData(
        x: DateTime(2003),
        y: 1.00,
        yValue: 0.09,
        secondSeriesYValue: 0.61,
        thirdSeriesYValue: 0.20,
      ),
      ChartSampleData(
        x: DateTime(2004),
        y: 1.19,
        yValue: 0.14,
        secondSeriesYValue: 0.63,
        thirdSeriesYValue: 0.23,
      ),
      ChartSampleData(
        x: DateTime(2005),
        y: 1.47,
        yValue: 0.20,
        secondSeriesYValue: 0.64,
        thirdSeriesYValue: 0.36,
      ),
      ChartSampleData(
        x: DateTime(2006),
        y: 1.74,
        yValue: 0.29,
        secondSeriesYValue: 0.66,
        thirdSeriesYValue: 0.43,
      ),
      ChartSampleData(
        x: DateTime(2007),
        y: 1.98,
        yValue: 0.46,
        secondSeriesYValue: 0.76,
        thirdSeriesYValue: 0.52,
      ),
      ChartSampleData(
        x: DateTime(2008),
        y: 1.99,
        yValue: 0.64,
        secondSeriesYValue: 0.77,
        thirdSeriesYValue: 0.72,
      ),
      ChartSampleData(
        x: DateTime(2009),
        y: 1.70,
        yValue: 0.75,
        secondSeriesYValue: 0.55,
        thirdSeriesYValue: 1.29,
      ),
      ChartSampleData(
        x: DateTime(2010),
        y: 1.48,
        yValue: 1.06,
        secondSeriesYValue: 0.54,
        thirdSeriesYValue: 1.38,
      ),
      ChartSampleData(
        x: DateTime(2011),
        y: 1.38,
        yValue: 1.25,
        secondSeriesYValue: 0.57,
        thirdSeriesYValue: 1.82,
      ),
      ChartSampleData(
        x: DateTime(2012),
        y: 1.66,
        yValue: 1.55,
        secondSeriesYValue: 0.61,
        thirdSeriesYValue: 2.16,
      ),
      ChartSampleData(
        x: DateTime(2013),
        y: 1.66,
        yValue: 1.55,
        secondSeriesYValue: 0.67,
        thirdSeriesYValue: 2.51,
      ),
      ChartSampleData(
        x: DateTime(2014),
        y: 1.67,
        yValue: 1.65,
        secondSeriesYValue: 0.67,
        thirdSeriesYValue: 2.61,
      ),
      ChartSampleData(
        x: DateTime(2015),
        y: 1.68,
        yValue: 1.75,
        secondSeriesYValue: 0.71,
        thirdSeriesYValue: 2.71,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
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
                        spacing: 40,
                        children: <Widget>[
                          Text(
                            'Position',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 16,
                              color: model.textColor,
                            ),
                          ),
                          Flexible(
                            child: DropdownButton<String>(
                              dropdownColor: model.drawerBackgroundColor,
                              focusColor: Colors.transparent,
                              isExpanded: true,
                              underline: Container(
                                color: const Color(0xFFBDBDBD),
                                height: 1,
                              ),
                              value: _selectedPosition,
                              items: _positionList!.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'auto',
                                  child: Text(
                                    value,
                                    style: TextStyle(color: model.textColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                _onPositionTypeChange(value.toString());
                                stateSetter(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 30,
                        children: <Widget>[
                          Text(
                            model.isWebFullView
                                ? 'Overflow \nmode'
                                : 'Overflow mode',
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 16,
                              color: model.textColor,
                            ),
                          ),
                          Flexible(
                            child: DropdownButton<String>(
                              dropdownColor: model.drawerBackgroundColor,
                              focusColor: Colors.transparent,
                              isExpanded: true,
                              underline: Container(
                                color: const Color(0xFFBDBDBD),
                                height: 1,
                              ),
                              value: _selectedMode,
                              items: _modeList!.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: (value != null) ? value : 'wrap',
                                  child: Text(
                                    value,
                                    style: TextStyle(color: model.textColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                _onModeTypeChange(value);
                                stateSetter(() {});
                              },
                            ),
                          ),
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
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(
                                right: model.isMobile
                                    ? 0.29 * screenWidth
                                    : 0.37 * screenWidth,
                              ),
                              width: dropDownWidth,
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
                              ),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(
                                right: model.isMobile
                                    ? 0.29 * screenWidth
                                    : 0.37 * screenWidth,
                              ),
                              width: dropDownWidth,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Text(
                              'X offset',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: CustomDirectionalButtons(
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
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Text(
                              'Y offset',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: CustomDirectionalButtons(
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
                          ),
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
      },
    );
  }

  /// Return the Cartesian Chart with StackedArea series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Sales comparison of fruits in a shop',
      ),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        labelFormat: '{value}B',
        interval: isCardView ? null : 1,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildStackedAreaSeries(),

      /// Legend and its options for Cartesian Chart.
      legend: Legend(
        isVisible: true,
        position: _position!,
        offset: _enableFloatingLegend ? Offset(_xOffset, _yOffset) : null,
        overflowMode: _overflowMode!,
        toggleSeriesVisibility: _toggleVisibility,
        backgroundColor: model.themeData.brightness == Brightness.light
            ? Colors.white.withValues(alpha: 0.5)
            : const Color.fromRGBO(33, 33, 33, 0.5),
        borderColor: model.themeData.brightness == Brightness.light
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.5),
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian StackedArea series.
  List<StackedAreaSeries<ChartSampleData, DateTime>> _buildStackedAreaSeries() {
    return <StackedAreaSeries<ChartSampleData, DateTime>>[
      StackedAreaSeries<ChartSampleData, DateTime>(
        dataSource: _fruitsSalesComparisonData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'Apple',
      ),
      StackedAreaSeries<ChartSampleData, DateTime>(
        dataSource: _fruitsSalesComparisonData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        name: 'Orange',
      ),
      StackedAreaSeries<ChartSampleData, DateTime>(
        dataSource: _fruitsSalesComparisonData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Pear',
      ),
      StackedAreaSeries<ChartSampleData, DateTime>(
        dataSource: _fruitsSalesComparisonData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: 'Others',
      ),
    ];
  }

  /// Method to update the selected position type change.
  void _onPositionTypeChange(String item) {
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
    setState(() {
      /// Update the legend position type changes.
    });
  }

  /// Method to update the selected overflow mode type change.
  void _onModeTypeChange(String item) {
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
    setState(() {
      /// Update the legend item overflow mode changes.
    });
  }

  @override
  void dispose() {
    _positionList!.clear();
    _modeList!.clear();
    _fruitsSalesComparisonData!.clear();
    super.dispose();
  }
}
