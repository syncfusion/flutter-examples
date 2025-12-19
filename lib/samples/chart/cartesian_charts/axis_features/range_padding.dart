/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Render the positioning axis label.
class RangePaddingView extends SampleView {
  const RangePaddingView(Key key) : super(key: key);

  @override
  _RangePaddingViewState createState() => _RangePaddingViewState();
}

/// State class of positioning axis label.
class _RangePaddingViewState extends SampleViewState {
  _RangePaddingViewState();

  late ChartRangePadding _rangePaddingX;
  late ChartRangePadding _rangePaddingY;
  List<String>? _rangePaddingTypeX;
  List<String>? _rangePaddingTypeY;
  late String _selectedRangeTypeX;
  late String _selectedRangeTypeY;
  late List<ChartSampleData> _salesProductData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _rangePaddingX = ChartRangePadding.auto;
    _rangePaddingY = ChartRangePadding.auto;
    _rangePaddingTypeX = <String>[
      'auto',
      'none',
      'additional',
      'additionalStart',
      'additionalEnd',
      'normal',
      'round',
      'roundStart',
      'roundEnd',
    ].toList();
    _rangePaddingTypeY = <String>[
      'auto',
      'none',
      'additional',
      'additionalStart',
      'additionalEnd',
      'normal',
      'round',
      'roundStart',
      'roundEnd',
    ].toList();
    _selectedRangeTypeX = 'auto';
    _selectedRangeTypeY = 'auto';
    _salesProductData = <ChartSampleData>[
      ChartSampleData(x: -7, y: -2.35),
      ChartSampleData(x: -6, y: 0),
      ChartSampleData(x: -4, y: 2.75),
      ChartSampleData(x: -2, y: -1),
      ChartSampleData(x: 0, y: 1),
      ChartSampleData(x: 2, y: 3.75),
      ChartSampleData(x: 4, y: 0),
      ChartSampleData(x: 6, y: 2.75),
      ChartSampleData(x: 7, y: 1.65),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              'X Axis',
              style: TextStyle(
                fontSize: 16.0,
                color: model.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Range padding',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Flexible(
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedRangeTypeX,
                    items: _rangePaddingTypeX!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'auto',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onRangePaddingChangeX(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Text(
              'Y Axis',
              style: TextStyle(
                fontSize: 16.0,
                color: model.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Range padding',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Flexible(
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedRangeTypeY,
                    items: _rangePaddingTypeY!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'auto',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onRangePaddingChangeY(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Product Sales'),
      primaryXAxis: NumericAxis(rangePadding: _rangePaddingX, interval: 2),
      primaryYAxis: NumericAxis(rangePadding: _rangePaddingY, interval: 1),
      series: _buildSplineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<CartesianSeries<ChartSampleData, dynamic>> _buildSplineSeries() {
    return <CartesianSeries<ChartSampleData, dynamic>>[
      SplineSeries<ChartSampleData, dynamic>(
        dataSource: _salesProductData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        name: 'Product Sales',
      ),
    ];
  }

  /// Method for range padding change.
  void _onRangePaddingChangeX(String item) {
    setState(() {
      _selectedRangeTypeX = item;
      switch (_selectedRangeTypeX) {
        case 'auto':
          _rangePaddingX = ChartRangePadding.auto;
          break;
        case 'additional':
          _rangePaddingX = ChartRangePadding.additional;
          break;
        case 'normal':
          _rangePaddingX = ChartRangePadding.normal;
          break;
        case 'round':
          _rangePaddingX = ChartRangePadding.round;
          break;
        case 'none':
          _rangePaddingX = ChartRangePadding.none;
          break;
        case 'additionalStart':
          _rangePaddingX = ChartRangePadding.additionalStart;
          break;
        case 'additionalEnd':
          _rangePaddingX = ChartRangePadding.additionalEnd;
          break;
        case 'roundStart':
          _rangePaddingX = ChartRangePadding.roundStart;
          break;
        case 'roundEnd':
          _rangePaddingX = ChartRangePadding.roundEnd;
          break;
      }
    });
  }

  void _onRangePaddingChangeY(String item) {
    setState(() {
      _selectedRangeTypeY = item;
      switch (_selectedRangeTypeY) {
        case 'auto':
          _rangePaddingY = ChartRangePadding.auto;
          break;
        case 'additional':
          _rangePaddingY = ChartRangePadding.additional;
          break;
        case 'normal':
          _rangePaddingY = ChartRangePadding.normal;
          break;
        case 'round':
          _rangePaddingY = ChartRangePadding.round;
          break;
        case 'none':
          _rangePaddingY = ChartRangePadding.none;
          break;
        case 'additionalStart':
          _rangePaddingY = ChartRangePadding.additionalStart;
          break;
        case 'additionalEnd':
          _rangePaddingY = ChartRangePadding.additionalEnd;
          break;
        case 'roundStart':
          _rangePaddingY = ChartRangePadding.roundStart;
          break;
        case 'roundEnd':
          _rangePaddingY = ChartRangePadding.roundEnd;
          break;
      }
    });
  }

  @override
  void dispose() {
    _rangePaddingTypeX!.clear();
    _rangePaddingTypeY!.clear();
    super.dispose();
  }
}
