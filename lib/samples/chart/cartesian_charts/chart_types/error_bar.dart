/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../widgets/custom_button.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with Error bar sample.
class ErrorBarDefault extends SampleView {
  /// Creates the chart with Error bar sample.
  const ErrorBarDefault(Key key) : super(key: key);

  @override
  _ErrorBarDefaultState createState() => _ErrorBarDefaultState();
}

class _ErrorBarDefaultState extends SampleViewState {
  _ErrorBarDefaultState();

  late String _errorBarMode;
  late String _errorBarType;
  late String _errorBarDirection;
  late RenderingMode _selectedErrorBarMode;
  late ErrorBarType _selectedErrorBarType;
  late Direction _selectedErrorBarDirection;
  double _verticalErrorValue = 3;
  double _horizontalErrorValue = 1;
  double _horizontalPositiveErrorValue = 1;
  double _verticalPositiveErrorValue = 2;
  double _horizontalNegativeErrorValue = 1;
  double _verticalNegativeErrorValue = 2;
  bool _isCustomTypeErrorBar = false;
  late TooltipBehavior _tooltipbehavior;

  final List<String> _errorBarModes = <String>[
    'vertical',
    'horizontal',
    'both'
  ];

  final List<String> _errorBarTypes = <String>[
    'fixed',
    'percentage',
    'standardError',
    'standardDeviation',
    'custom'
  ].toList();

  final List<String> _errorBarDirections =
      <String>['plus', 'minus', 'both'].toList();

  @override
  void initState() {
    super.initState();
    _errorBarMode = 'vertical';
    _errorBarType = 'fixed';
    _errorBarDirection = 'both';
    _selectedErrorBarDirection = Direction.both;
    _selectedErrorBarMode = RenderingMode.vertical;
    _selectedErrorBarType = ErrorBarType.fixed;
    _tooltipbehavior = TooltipBehavior(enable: true);
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
    final double screenWidth =
        model.isWebFullView ? 255 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
              title: Text('Error bar \ntype',
                  softWrap: false,
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.54 * screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                    isExpanded: true,
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _errorBarType,
                    items: _errorBarTypes.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              softWrap: false,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (String? value) {
                      _updateErrorBarType(value!);
                      if (_errorBarType != 'custom') {
                        _isCustomTypeErrorBar = false;
                      }
                      stateSetter(() {});
                    }),
              )),
          ListTile(
              title: Text('Direction',
                  softWrap: false,
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.54 * screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                    isExpanded: true,
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _errorBarDirection,
                    items: _errorBarDirections.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              softWrap: false,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (String? value) {
                      _updateDirection(value!);
                      stateSetter(() {});
                    }),
              )),
          ListTile(
              title: Text('Drawing \nmode',
                  softWrap: false,
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                padding: EdgeInsets.only(left: 0.07 * screenWidth),
                width: 0.54 * screenWidth,
                height: 50,
                alignment: Alignment.center,
                child: DropdownButton<String>(
                    isExpanded: true,
                    underline:
                        Container(color: const Color(0xFFBDBDBD), height: 1),
                    value: _errorBarMode,
                    items: _errorBarModes.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              softWrap: false,
                              style: TextStyle(color: model.textColor)));
                    }).toList(),
                    onChanged: (String? value) {
                      _updateErrorBarMode(value!);
                      stateSetter(() {});
                    }),
              )),
          Visibility(
            visible: !_isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Vertical \nerror',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
                  child: CustomDirectionalButtons(
                    minValue: 2,
                    maxValue: 10,
                    initialValue: _verticalErrorValue,
                    onChanged: (double val) => setState(() {
                      _verticalErrorValue = (_errorBarMode == 'vertical' ||
                              _errorBarMode == 'both')
                          ? val
                          : 0;
                    }),
                    step:
                        (_errorBarMode == 'vertical' || _errorBarMode == 'both')
                            ? 1
                            : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        (_errorBarMode == 'vertical' || _errorBarMode == 'both')
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: model.textColor.withOpacity(
                            (_errorBarMode == 'vertical' ||
                                    _errorBarMode == 'both')
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
          Visibility(
            visible: !_isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Horizontal \nerror',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
                  child: CustomDirectionalButtons(
                    minValue: 1,
                    maxValue: 10,
                    initialValue: _horizontalErrorValue,
                    onChanged: (double val) => setState(() {
                      _horizontalErrorValue = (_errorBarMode == 'horizontal' ||
                              _errorBarMode == 'both')
                          ? val
                          : 0;
                    }),
                    step: (_errorBarMode == 'horizontal' ||
                            _errorBarMode == 'both')
                        ? 1
                        : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        (_errorBarMode == 'horizontal' ||
                                _errorBarMode == 'both')
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: model.textColor.withOpacity(
                            (_errorBarMode == 'horizontal' ||
                                    _errorBarMode == 'both')
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
          Visibility(
            visible: _isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Horizontal \npositive',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
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
                    step: ((_errorBarMode == 'horizontal' ||
                                _errorBarMode == 'both') &&
                            (_errorBarDirection == 'plus' ||
                                _errorBarDirection == 'both'))
                        ? 1
                        : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        ((_errorBarMode == 'horizontal' ||
                                    _errorBarMode == 'both') &&
                                (_errorBarDirection == 'plus' ||
                                    _errorBarDirection == 'both'))
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: model.textColor.withOpacity(
                            ((_errorBarMode == 'horizontal' ||
                                        _errorBarMode == 'both') &&
                                    (_errorBarDirection == 'plus' ||
                                        _errorBarDirection == 'both'))
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
          Visibility(
            visible: _isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Horizontal \nnegative',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
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
                    step: ((_errorBarMode == 'horizontal' ||
                                _errorBarMode == 'both') &&
                            (_errorBarDirection == 'minus' ||
                                _errorBarDirection == 'both'))
                        ? 1
                        : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        ((_errorBarMode == 'horizontal' ||
                                    _errorBarMode == 'both') &&
                                (_errorBarDirection == 'minus' ||
                                    _errorBarDirection == 'both'))
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: model.textColor.withOpacity(
                            ((_errorBarMode == 'horizontal' ||
                                        _errorBarMode == 'both') &&
                                    (_errorBarDirection == 'minus' ||
                                        _errorBarDirection == 'both'))
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
          Visibility(
            visible: _isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Vertical \nnegative',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
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
                    step: ((_errorBarMode == 'vertical' ||
                                _errorBarMode == 'both') &&
                            (_errorBarDirection == 'minus' ||
                                _errorBarDirection == 'both'))
                        ? 1
                        : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        ((_errorBarMode == 'vertical' ||
                                    _errorBarMode == 'both') &&
                                (_errorBarDirection == 'minus' ||
                                    _errorBarDirection == 'both'))
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: model.textColor.withOpacity(
                            ((_errorBarMode == 'vertical' ||
                                        _errorBarMode == 'both') &&
                                    (_errorBarDirection == 'minus' ||
                                        _errorBarDirection == 'both'))
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
          Visibility(
            visible: _isCustomTypeErrorBar,
            child: ListTile(
                title: Text('Vertical \npositive',
                    softWrap: false,
                    style: TextStyle(
                      color: model.textColor,
                    )),
                trailing: Container(
                  width: 0.52 * screenWidth,
                  height: 50,
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
                    step: ((_errorBarMode == 'vertical' ||
                                _errorBarMode == 'both') &&
                            (_errorBarDirection == 'plus' ||
                                _errorBarDirection == 'both'))
                        ? 1
                        : 0,
                    horizontal: true,
                    loop: false,
                    padding: 0,
                    iconColor: model.textColor.withOpacity(
                        ((_errorBarMode == 'vertical' ||
                                    _errorBarMode == 'both') &&
                                (_errorBarDirection == 'plus' ||
                                    _errorBarDirection == 'both'))
                            ? 1
                            : 0.5),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: model.textColor.withOpacity(
                            ((_errorBarMode == 'vertical' ||
                                        _errorBarMode == 'both') &&
                                    (_errorBarDirection == 'plus' ||
                                        _errorBarDirection == 'both'))
                                ? 1
                                : 0.5)),
                  ),
                )),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dynamic chartData = <SalesData>[
      SalesData('IND', 24, Colors.blueAccent),
      SalesData('AUS', 20, Colors.black),
      SalesData('USA', 35, Colors.deepOrangeAccent),
      SalesData('DEU', 27, Colors.green),
      SalesData('ITA', 30, Colors.orange),
      SalesData('UK', 41, Colors.blueGrey),
      SalesData('RUS', 26, Colors.greenAccent)
    ];

    return Padding(
      padding:
          EdgeInsets.only(bottom: model.isWebFullView || !isCardView ? 0 : 60),
      child: SfCartesianChart(
        title: ChartTitle(text: 'Sales distribution of cars by region'),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            interval: 1, majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}%',
            interval: 10,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(color: Colors.transparent)),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(
              details.axisName == 'primaryXAxis' &&
                      details.text.contains(RegExp(r'[0-9]'))
                  ? ''
                  : details.text,
              null);
        },
        tooltipBehavior: _tooltipbehavior,
        series: <ChartSeries<SalesData, dynamic>>[
          ScatterSeries<SalesData, dynamic>(
            dataSource: chartData,
            name: 'Sales',
            animationDuration: 1000,
            xValueMapper: (SalesData sales, _) => sales.country,
            yValueMapper: (SalesData sales, _) => sales.salesCount,
            isVisible: true,
          ),
          ErrorBarSeries<SalesData, dynamic>(
            dataSource: chartData,
            animationDuration: 1000,
            animationDelay: 1000,
            xValueMapper: (SalesData sales, _) => sales.country,
            yValueMapper: (SalesData sales, _) => sales.salesCount,
            isVisible: true,
            color: model.themeData.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
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
            capLength: 10.0,
          ),
        ],
      ),
    );
  }
}

/// Class for storing sales data
class SalesData {
  /// constructor for SalesData
  SalesData(this.country, this.salesCount, this.color);

  /// Sales producing country
  final String country;

  /// Number of sales
  final int salesCount;

  /// Color of scatter point
  final Color color;
}
