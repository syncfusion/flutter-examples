/// Package imports.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Render the default trendline Chart sample.
class TrendLineDefault extends SampleView {
  const TrendLineDefault(Key key) : super(key: key);

  @override
  _TrendLineDefaultState createState() => _TrendLineDefaultState();
}

/// State class of default trendline Chart.
class _TrendLineDefaultState extends SampleViewState {
  _TrendLineDefaultState();

  bool? _displayRSquare;
  bool? _displaySlopeEquation;
  late String _slopeEquation;
  late String _rSquare;
  late int periodMaxValue;
  late String _selectedTrendLineType;
  List<String>? _trendlineTypeList;
  late TrendlineType _type;
  late int _polynomialOrder;
  late int _period;
  TooltipBehavior? _tooltipBehavior;
  late bool isLegendTapped;
  Size? slopeTextSize;
  late double? _intercept;
  List<double>? _slope;
  List<ChartSampleData>? _websiteVisitorsData;

  @override
  void initState() {
    _displayRSquare = false;
    _displaySlopeEquation = false;
    _slopeEquation = '';
    _rSquare = '';
    periodMaxValue = 0;
    _selectedTrendLineType = 'linear';
    _trendlineTypeList = <String>[
      'linear',
      'exponential',
      'power',
      'logarithmic',
      'polynomial',
      'movingAverage',
    ].toList();
    _type = TrendlineType.linear;
    _polynomialOrder = 2;
    _period = 2;
    _tooltipBehavior = TooltipBehavior(enable: true);
    isLegendTapped = false;
    _websiteVisitorsData = <ChartSampleData>[
      ChartSampleData(text: 'Sun', yValue: 12500),
      ChartSampleData(text: 'Mon', yValue: 14000),
      ChartSampleData(text: 'Tue', yValue: 22000),
      ChartSampleData(text: 'Wed', yValue: 26000),
      ChartSampleData(text: 'Thu', yValue: 19000),
      ChartSampleData(text: 'Fri', yValue: 28000),
      ChartSampleData(text: 'Sat', yValue: 32000),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart(context);
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth =
        (model.isWebFullView ? 0.72 : 0.57) * screenWidth;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Trendline \ntype',
                  style: TextStyle(color: model.textColor),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    model.isWebFullView ? 30 : 70,
                    0,
                    0,
                    0,
                  ),
                  width: dropDownWidth,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    isExpanded: !model.isWebFullView,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedTrendLineType,
                    items: _trendlineTypeList!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textWidthBasis: TextWidthBasis.parent,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        _onTrendLineTypeChanged(value.toString());
                        stateSetter(() {});
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Display slope \nequation',
                    style: TextStyle(color: model.textColor),
                  ),
                  SizedBox(
                    width: 0.5 * screenWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CheckboxListTile(
                        activeColor: model.primaryColor,
                        value: _displaySlopeEquation,
                        onChanged: _type == TrendlineType.movingAverage
                            ? null
                            : (bool? value) {
                                setState(() {
                                  _displaySlopeEquation = value;
                                  stateSetter(() {});
                                });
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Display \nR - squared  \nvalue',
                    style: TextStyle(color: model.textColor),
                  ),
                  SizedBox(
                    width: 0.5 * screenWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CheckboxListTile(
                        activeColor: model.primaryColor,
                        value: _displayRSquare,
                        onChanged: _type == TrendlineType.movingAverage
                            ? null
                            : (bool? value) {
                                setState(() {
                                  _displayRSquare = value;
                                  stateSetter(() {});
                                });
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Visibility(
                visible: _selectedTrendLineType != 'polynomial' ? false : true,
                maintainState: true,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Polynomial\norder',
                      style: TextStyle(color: model.textColor),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomDirectionalButtons(
                          minValue: 2,
                          maxValue: 4,
                          initialValue: _polynomialOrder.toDouble(),
                          onChanged: (double val) => setState(() {
                            _polynomialOrder = val.floor();
                          }),
                          loop: true,
                          iconColor: model.textColor,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: model.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Visibility(
                visible: _selectedTrendLineType != 'movingAverage'
                    ? false
                    : true,
                maintainState: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Period',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: model.textColor),
                    ),
                    Container(
                      height: 20.0,
                      padding: EdgeInsets.fromLTRB(
                        model.isWebFullView ? 50 : 70,
                        0,
                        0,
                        0,
                      ),
                      child: CustomDirectionalButtons(
                        minValue: 2,
                        maxValue: periodMaxValue.toDouble(),
                        initialValue: _period.toDouble(),
                        onChanged: (double val) => setState(() {
                          _period = val.floor();
                        }),
                        loop: true,
                        iconColor: model.textColor,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'No. of website visitors in a week',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Visitors'),
        majorTickLines: const MajorTickLines(width: 0),
        numberFormat: NumberFormat.compact(),
        axisLine: const AxisLine(width: 0),
        interval: !isCardView ? 5000 : 10000,
        labelFormat: '{value}',
        maximum: 40000,
      ),
      series: _buildColumnSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      legend: Legend(isVisible: !isCardView),
      onLegendTapped: (LegendTapArgs args) {
        setState(() {
          isLegendTapped = isLegendTapped == true ? false : true;
        });
      },
      tooltipBehavior: _tooltipBehavior,
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: SizedBox(
            height: kIsWeb
                ? 60
                : orientation == Orientation.landscape
                ? 50
                : 90,
            width: kIsWeb
                ? slopeTextSize != null && slopeTextSize!.width > 200
                      ? slopeTextSize!.width
                      : 200
                : slopeTextSize != null && slopeTextSize!.width > 170
                ? orientation == Orientation.portrait
                      ? 220
                      : slopeTextSize!.width
                : 170,
            child: Visibility(
              visible: !isLegendTapped,
              child: Column(
                children: <Widget>[
                  // ignore: prefer_if_elements_to_conditional_expressions
                  (_displaySlopeEquation != null &&
                          _displaySlopeEquation! &&
                          _type != TrendlineType.movingAverage)
                      ? Text(
                          _slopeEquation,
                          style: TextStyle(color: model.textColor),
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Text(''),
                  SizedBox(
                    height: kIsWeb
                        ? 15
                        : orientation == Orientation.landscape
                        ? 8
                        : 20,
                  ),
                  // ignore: prefer_if_elements_to_conditional_expressions
                  (_displayRSquare != null &&
                          _displayRSquare! &&
                          _type != TrendlineType.movingAverage)
                      ? Text(
                          'R² = ' + _rSquare,
                          style: TextStyle(color: model.textColor),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: model.isWebFullView
              ? slopeTextSize != null && slopeTextSize!.width > 200
                    ? 'Thu'
                    : 'Fri'
              : slopeTextSize != null && slopeTextSize!.width > 170
              ? 'Wed'
              : 'Thu',
          y: 34000,
        ),
      ],
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    periodMaxValue = 6;
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(99, 85, 199, 1)
              : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _websiteVisitorsData,
        xValueMapper: (ChartSampleData data, int index) => data.text,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        name: 'Visitors count',
        trendlines: <Trendline>[
          Trendline(
            type: _type,
            width: 3,
            color: color,
            dashArray: <double>[15, 3, 3, 3],
            polynomialOrder: _polynomialOrder,
            period: _period,
            onRenderDetailsUpdate: (TrendlineRenderParams args) {
              _rSquare = double.parse(
                args.rSquaredValue!.toStringAsFixed(4),
              ).toString();
              _slope = args.slope;
              _intercept = args.intercept;
              _createSlopeEquation(_slope, _intercept);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_displayRSquare! || _displaySlopeEquation!) {
                  setState(() {});
                }
              });
            },
          ),
        ],
      ),
    ];
  }

  void _createSlopeEquation(List<double>? slope, double? intercept) {
    if (_type == TrendlineType.linear) {
      _slopeEquation =
          'y = ${double.parse(slope![0].toStringAsFixed(3))}x + ${double.parse(intercept!.toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.exponential) {
      _slopeEquation =
          'y = ${double.parse(intercept!.toStringAsFixed(3))}e^${double.parse(slope![0].toStringAsFixed(3))}x';
    }
    if (_type == TrendlineType.logarithmic) {
      _slopeEquation =
          'y = ${double.parse(intercept!.toStringAsFixed(3))}ln(x) + ${double.parse(slope![0].toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.polynomial) {
      if (_polynomialOrder == 2) {
        _slopeEquation =
            'y = ${double.parse(slope![1].toStringAsFixed(3))}x +  ${double.parse(slope[0].toStringAsFixed(3))}';
      }
      if (_polynomialOrder == 3) {
        _slopeEquation =
            'y = ${double.parse(slope![2].toStringAsFixed(3))}x² + ${double.parse(slope[1].toStringAsFixed(3))}x + ${double.parse(slope[0].toStringAsFixed(3))}';
      }
      if (_polynomialOrder == 4) {
        _slopeEquation =
            'y = ${double.parse(slope![3].toStringAsFixed(3))}x³ + ${double.parse(slope[2].toStringAsFixed(3))}x²  + ${double.parse(slope[1].toStringAsFixed(3))}x + ${double.parse(slope[0].toStringAsFixed(3))}';
      }
    }
    if (_type == TrendlineType.power) {
      _slopeEquation =
          'y = ${double.parse(intercept!.toStringAsFixed(3))}x^${double.parse(slope![0].toStringAsFixed(3))}';
    }
    if (_type == TrendlineType.movingAverage) {
      _slopeEquation = '';
    }
    slopeTextSize = measureText(
      _slopeEquation,
      TextStyle(color: model.textColor),
    );
  }

  /// Method to update the selected trendline type for the Chart.
  void _onTrendLineTypeChanged(String item) {
    _selectedTrendLineType = item;
    switch (_selectedTrendLineType) {
      case 'linear':
        _type = TrendlineType.linear;
        break;
      case 'exponential':
        _type = TrendlineType.exponential;
        break;
      case 'power':
        _type = TrendlineType.power;
        break;
      case 'logarithmic':
        _type = TrendlineType.logarithmic;
        break;
      case 'polynomial':
        _type = TrendlineType.polynomial;
        break;
      case 'movingAverage':
        _type = TrendlineType.movingAverage;
        break;
    }
    setState(() {
      /// Update the trend line changes.
    });
  }

  @override
  void dispose() {
    if (_slope != null) {
      _slope = [];
    }
    _trendlineTypeList!.clear();
    _websiteVisitorsData!.clear();
    super.dispose();
  }
}
