/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../widgets/custom_button.dart';
import '../../../../model/sample_view.dart';

/// Renders the Chart with Error Bar sample.
class ErrorBarDefault extends SampleView {
  const ErrorBarDefault(Key key) : super(key: key);

  @override
  _ErrorBarDefaultState createState() => _ErrorBarDefaultState();
}

class _ErrorBarDefaultState extends SampleViewState {
  _ErrorBarDefaultState();

  late String _errorBarMode;
  late String _errorBarType;
  late String _errorBarDirection;
  late double _verticalErrorValue;
  late double _horizontalErrorValue;
  late double _horizontalPositiveErrorValue;
  late double _verticalPositiveErrorValue;
  late double _horizontalNegativeErrorValue;
  late double _verticalNegativeErrorValue;
  late bool _isCustomTypeErrorBar;
  List<String>? _errorBarModes;
  List<String>? _errorBarTypes;
  List<String>? _errorBarDirections;
  RenderingMode? _selectedErrorBarMode;
  ErrorBarType? _selectedErrorBarType;
  Direction? _selectedErrorBarDirection;
  Color? _errorBarColor;
  List<SalesData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _verticalErrorValue = 3;
    _horizontalErrorValue = 1;
    _horizontalPositiveErrorValue = 1;
    _verticalPositiveErrorValue = 2;
    _horizontalNegativeErrorValue = 1;
    _verticalNegativeErrorValue = 2;
    _isCustomTypeErrorBar = false;
    _errorBarMode = 'vertical';
    _errorBarType = 'fixed';
    _errorBarDirection = 'both';
    _selectedErrorBarDirection = Direction.both;
    _selectedErrorBarMode = RenderingMode.vertical;
    _selectedErrorBarType = ErrorBarType.fixed;
    _errorBarDirections = <String>['plus', 'minus', 'both'].toList();
    _errorBarTypes = <String>[
      'fixed',
      'percentage',
      'standardError',
      'standardDeviation',
      'custom',
    ].toList();
    _errorBarModes = <String>['vertical', 'horizontal', 'both'];
    _chartData = <SalesData>[
      SalesData('IND', 24, Colors.blueAccent),
      SalesData('AUS', 20, Colors.black),
      SalesData('USA', 35, Colors.deepOrangeAccent),
      SalesData('DEU', 27, Colors.green),
      SalesData('ITA', 30, Colors.orange),
      SalesData('UK', 41, Colors.blueGrey),
      SalesData('RUS', 26, Colors.greenAccent),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize error bar color based on the current theme
    _errorBarColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  void _updateErrorBarType(String value) {
    _errorBarType = value;
    if (_errorBarType == 'fixed') {
      _selectedErrorBarType = ErrorBarType.fixed;
    }
    if (_errorBarType == 'percentage') {
      _selectedErrorBarType = ErrorBarType.percentage;
    }
    if (_errorBarType == 'standardError') {
      _selectedErrorBarType = ErrorBarType.standardError;
    }
    if (_errorBarType == 'standardDeviation') {
      _selectedErrorBarType = ErrorBarType.standardDeviation;
    }
    if (_errorBarType == 'custom') {
      _isCustomTypeErrorBar = true;
      _selectedErrorBarType = ErrorBarType.custom;
    }
    setState(() {});
  }

  void _updateDirection(String value) {
    _errorBarDirection = value;
    if (_errorBarDirection == 'plus') {
      _selectedErrorBarDirection = Direction.plus;
    }
    if (_errorBarDirection == 'minus') {
      _selectedErrorBarDirection = Direction.minus;
    }
    if (_errorBarDirection == 'both') {
      _selectedErrorBarDirection = Direction.both;
    }
    setState(() {});
  }

  void _updateErrorBarMode(String value) {
    _errorBarMode = value;
    if (_errorBarMode == 'vertical') {
      _selectedErrorBarMode = RenderingMode.vertical;
    }
    if (_errorBarMode == 'horizontal') {
      _selectedErrorBarMode = RenderingMode.horizontal;
    }
    if (_errorBarMode == 'both') {
      _selectedErrorBarMode = RenderingMode.both;
    }
    setState(() {});
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.8 * screenWidth;
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
                            child: Text(
                              'Error bar \ntype',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<String>(
                                dropdownColor: model.drawerBackgroundColor,
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                  color: const Color(0xFFBDBDBD),
                                  height: 1,
                                ),
                                value: _errorBarType,
                                items: _errorBarTypes!.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      softWrap: false,
                                      style: TextStyle(color: model.textColor),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  _updateErrorBarType(value!);
                                  if (_errorBarType != 'custom') {
                                    _isCustomTypeErrorBar = false;
                                  }
                                  stateSetter(() {});
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
                            child: Text(
                              'Direction',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<String>(
                                dropdownColor: model.drawerBackgroundColor,
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                  color: const Color(0xFFBDBDBD),
                                  height: 1,
                                ),
                                value: _errorBarDirection,
                                items: _errorBarDirections!.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      softWrap: false,
                                      style: TextStyle(color: model.textColor),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  _updateDirection(value!);
                                  stateSetter(() {});
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
                            child: Text(
                              'Drawing \nmode',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              width: dropDownWidth,
                              child: DropdownButton<String>(
                                dropdownColor: model.drawerBackgroundColor,
                                focusColor: Colors.transparent,
                                isExpanded: true,
                                underline: Container(
                                  color: const Color(0xFFBDBDBD),
                                  height: 1,
                                ),
                                value: _errorBarMode,
                                items: _errorBarModes!.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      softWrap: false,
                                      style: TextStyle(color: model.textColor),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  _updateErrorBarMode(value!);
                                  stateSetter(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: !_isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Vertical \nerror',
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
                                minValue: 2,
                                maxValue: 10,
                                initialValue: _verticalErrorValue,
                                onChanged: (double val) => setState(() {
                                  _verticalErrorValue =
                                      (_errorBarMode == 'vertical' ||
                                          _errorBarMode == 'both')
                                      ? val
                                      : 0;
                                }),
                                step:
                                    (_errorBarMode == 'vertical' ||
                                        _errorBarMode == 'both')
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      (_errorBarMode == 'vertical' ||
                                          _errorBarMode == 'both')
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: model.textColor.withValues(
                                    alpha:
                                        (_errorBarMode == 'vertical' ||
                                            _errorBarMode == 'both')
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: !_isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Horizontal \nerror',
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
                                minValue: 1,
                                maxValue: 10,
                                initialValue: _horizontalErrorValue,
                                onChanged: (double val) => setState(() {
                                  _horizontalErrorValue =
                                      (_errorBarMode == 'horizontal' ||
                                          _errorBarMode == 'both')
                                      ? val
                                      : 0;
                                }),
                                step:
                                    (_errorBarMode == 'horizontal' ||
                                        _errorBarMode == 'both')
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      (_errorBarMode == 'horizontal' ||
                                          _errorBarMode == 'both')
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: model.textColor.withValues(
                                    alpha:
                                        (_errorBarMode == 'horizontal' ||
                                            _errorBarMode == 'both')
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: _isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Horizontal \npositive',
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
                                minValue: 1,
                                maxValue: 10,
                                initialValue: _horizontalPositiveErrorValue,
                                onChanged: (double val) => setState(() {
                                  _horizontalPositiveErrorValue =
                                      ((_errorBarMode == 'horizontal' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'plus' ||
                                              _errorBarDirection == 'both'))
                                      ? val
                                      : 0;
                                }),
                                step:
                                    ((_errorBarMode == 'horizontal' ||
                                            _errorBarMode == 'both') &&
                                        (_errorBarDirection == 'plus' ||
                                            _errorBarDirection == 'both'))
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      ((_errorBarMode == 'horizontal' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'plus' ||
                                              _errorBarDirection == 'both'))
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: model.textColor.withValues(
                                    alpha:
                                        ((_errorBarMode == 'horizontal' ||
                                                _errorBarMode == 'both') &&
                                            (_errorBarDirection == 'plus' ||
                                                _errorBarDirection == 'both'))
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: _isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Horizontal \nnegative',
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
                                minValue: 1,
                                maxValue: 10,
                                initialValue: _horizontalNegativeErrorValue,
                                onChanged: (double val) => setState(() {
                                  _horizontalNegativeErrorValue =
                                      ((_errorBarMode == 'horizontal' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'minus' ||
                                              _errorBarDirection == 'both'))
                                      ? val
                                      : 0;
                                }),
                                step:
                                    ((_errorBarMode == 'horizontal' ||
                                            _errorBarMode == 'both') &&
                                        (_errorBarDirection == 'minus' ||
                                            _errorBarDirection == 'both'))
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      ((_errorBarMode == 'horizontal' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'minus' ||
                                              _errorBarDirection == 'both'))
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: model.textColor.withValues(
                                    alpha:
                                        ((_errorBarMode == 'horizontal' ||
                                                _errorBarMode == 'both') &&
                                            (_errorBarDirection == 'minus' ||
                                                _errorBarDirection == 'both'))
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: _isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Vertical \nnegative',
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
                                minValue: 2,
                                maxValue: 10,
                                initialValue: _verticalNegativeErrorValue,
                                onChanged: (double val) => setState(() {
                                  _verticalNegativeErrorValue =
                                      ((_errorBarMode == 'vertical' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'minus' ||
                                              _errorBarDirection == 'both'))
                                      ? val
                                      : 0;
                                }),
                                step:
                                    ((_errorBarMode == 'vertical' ||
                                            _errorBarMode == 'both') &&
                                        (_errorBarDirection == 'minus' ||
                                            _errorBarDirection == 'both'))
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      ((_errorBarMode == 'vertical' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'minus' ||
                                              _errorBarDirection == 'both'))
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: model.textColor.withValues(
                                    alpha:
                                        ((_errorBarMode == 'vertical' ||
                                                _errorBarMode == 'both') &&
                                            (_errorBarDirection == 'minus' ||
                                                _errorBarDirection == 'both'))
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: model.isMobile ? 0.0 : 10.0),
                      Visibility(
                        visible: _isCustomTypeErrorBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 3,
                              child: Text(
                                'Vertical \npositive',
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
                                minValue: 2,
                                maxValue: 50,
                                initialValue: _verticalPositiveErrorValue,
                                onChanged: (double val) => setState(() {
                                  _verticalPositiveErrorValue =
                                      ((_errorBarMode == 'vertical' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'plus' ||
                                              _errorBarDirection == 'both'))
                                      ? val
                                      : 0;
                                }),
                                step:
                                    ((_errorBarMode == 'vertical' ||
                                            _errorBarMode == 'both') &&
                                        (_errorBarDirection == 'plus' ||
                                            _errorBarDirection == 'both'))
                                    ? 1
                                    : 0,
                                iconColor: model.textColor.withValues(
                                  alpha:
                                      ((_errorBarMode == 'vertical' ||
                                              _errorBarMode == 'both') &&
                                          (_errorBarDirection == 'plus' ||
                                              _errorBarDirection == 'both'))
                                      ? 1
                                      : 0.5,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: model.textColor.withValues(
                                    alpha:
                                        ((_errorBarMode == 'vertical' ||
                                                _errorBarMode == 'both') &&
                                            (_errorBarDirection == 'plus' ||
                                                _errorBarDirection == 'both'))
                                        ? 1
                                        : 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: model.isWebFullView || !isCardView ? 0 : 60,
      ),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: const ChartTitle(text: 'Sales distribution of cars by region'),
        primaryXAxis: CategoryAxis(
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
              details.axis.name == 'primaryXAxis' &&
                      details.text.contains(RegExp(r'[0-9]'))
                  ? ''
                  : details.text,
              null,
            );
          },
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          interval: 10,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
              details.axis.name == 'primaryXAxis' &&
                      details.text.contains(RegExp(r'[0-9]'))
                  ? ''
                  : details.text,
              null,
            );
          },
        ),
        series: <CartesianSeries<SalesData, dynamic>>[
          ScatterSeries<SalesData, dynamic>(
            dataSource: _chartData,
            xValueMapper: (SalesData sales, int index) => sales.country,
            yValueMapper: (SalesData sales, int index) => sales.salesCount,
            name: 'Sales',
            animationDuration: 1000,
          ),
          ErrorBarSeries<SalesData, dynamic>(
            dataSource: _chartData,
            xValueMapper: (SalesData sales, int index) => sales.country,
            yValueMapper: (SalesData sales, int index) => sales.salesCount,
            animationDuration: 1000,
            animationDelay: 1000,
            color: _errorBarColor,
            type: _selectedErrorBarType,
            verticalErrorValue: _verticalErrorValue,
            horizontalErrorValue: _horizontalErrorValue,
            mode: _selectedErrorBarMode,
            direction: _selectedErrorBarDirection,
            verticalNegativeErrorValue: _verticalNegativeErrorValue,
            verticalPositiveErrorValue: _verticalPositiveErrorValue,
            horizontalNegativeErrorValue: _horizontalNegativeErrorValue,
            horizontalPositiveErrorValue: _horizontalPositiveErrorValue,
            width: 1.0,
          ),
        ],
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }

  @override
  void dispose() {
    _errorBarModes!.clear();
    _errorBarTypes!.clear();
    _errorBarDirections!.clear();
    _chartData!.clear();
    super.dispose();
  }
}

/// Class for storing sales data.
class SalesData {
  SalesData(this.country, this.salesCount, this.color);

  /// Sales producing Country.
  final String country;

  /// Number of sales.
  final int salesCount;

  /// Color of Scatter point.
  final Color color;
}
