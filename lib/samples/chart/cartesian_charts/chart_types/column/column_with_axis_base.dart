/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Spline Chart with axis crossing sample.
class ColumnAxisCrossingBaseValue extends SampleView {
  const ColumnAxisCrossingBaseValue(Key key) : super(key: key);

  @override
  _AxisCrossingBaseValueState createState() => _AxisCrossingBaseValueState();
}

/// State class of the Spline Chart with axis crossing.
class _AxisCrossingBaseValueState extends SampleViewState {
  _AxisCrossingBaseValueState();

  List<String>? _axis;
  //ignore: unused_field
  String? _selectedAxisType;
  String? _selectedAxis;
  double? _crossAt;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _selectedAxisType = '-2 (modified)';
    _selectedAxis = '-2 (modified)';
    _crossAt = -2;
    _axis = <String>['-2 (modified)', '0 (default)'].toList();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Iceland',
        y: 1.13,
        pointColor: const Color.fromRGBO(107, 189, 98, 1),
      ),
      ChartSampleData(
        x: 'Algeria',
        y: 1.7,
        pointColor: const Color.fromRGBO(107, 189, 98, 1),
      ),
      ChartSampleData(
        x: 'Singapore',
        y: 1.82,
        pointColor: const Color.fromRGBO(107, 189, 98, 1),
      ),
      ChartSampleData(
        x: 'Malaysia',
        y: 1.37,
        pointColor: const Color.fromRGBO(107, 189, 98, 1),
      ),
      ChartSampleData(
        x: 'Moldova',
        y: -1.05,
        pointColor: const Color.fromRGBO(199, 86, 86, 1),
      ),
      ChartSampleData(
        x: 'American Samoa',
        y: -1.3,
        pointColor: const Color.fromRGBO(199, 86, 86, 1),
      ),
      ChartSampleData(
        x: 'Latvia',
        y: -1.1,
        pointColor: const Color.fromRGBO(199, 86, 86, 1),
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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Axis base value ',
              style: TextStyle(fontSize: 16.0, color: model.textColor),
            ),
            DropdownButton<String>(
              dropdownColor: model.drawerBackgroundColor,
              underline: Container(color: const Color(0xFFBDBDBD), height: 1),
              value: _selectedAxis,
              items: _axis!.map((String value) {
                return DropdownMenuItem<String>(
                  value: (value != null) ? value : '-2 (modified)',
                  child: Text(value, style: TextStyle(color: model.textColor)),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _onAxisTypeChange(value.toString());
                stateSetter(() {});
              },
            ),
          ],
        );
      },
    );
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Population growth rate of countries',
      ),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.wrap,
        crossesAt: _crossAt,
        placeLabelsNearAxisLine: false,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        minimum: -2,
        maximum: 2,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<CartesianSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        pointColorMapper: (ChartSampleData sales, int index) =>
            sales.pointColor,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
      ),
    ];
  }

  /// Method for updating the axis type on change.
  void _onAxisTypeChange(String item) {
    _selectedAxis = item;
    if (_selectedAxis == '-2 (modified)') {
      _selectedAxisType = '-2 (modified)';
      _crossAt = -2;
    } else if (_selectedAxis == '0 (default)') {
      _selectedAxisType = '0 (default)';
      _crossAt = 0;
    }
    setState(() {
      /// Update the axis type changes.
    });
  }

  @override
  void dispose() {
    _axis!.clear();
    _chartData!.clear();
    super.dispose();
  }
}
