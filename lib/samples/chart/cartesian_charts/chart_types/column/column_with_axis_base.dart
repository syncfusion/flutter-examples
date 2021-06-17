/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Package import
import 'package:flutter/material.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the spline chart with axis crossing sample.
class ColumnAxisCrossingBaseValue extends SampleView {
  ///Creates default axis crossing sample, chart widget
  const ColumnAxisCrossingBaseValue(Key key) : super(key: key);

  @override
  _AxisCrossingBaseValueState createState() => _AxisCrossingBaseValueState();
}

/// State class of the spline chart with axis crossing.
class _AxisCrossingBaseValueState extends SampleViewState {
  _AxisCrossingBaseValueState();
  final List<String> _axis = <String>['-2 (modified)', '0 (default)'].toList();
  //ignore: unused_field
  String _selectedAxisType = '-2 (modified)';
  late String _selectedAxis;
  double _crossAt = 0;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedAxisType = '-2 (modified)';
    _selectedAxis = '-2 (modified)';
    _crossAt = -2;
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAxisCrossingBaseValueSample();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Axis base value ',
              style: TextStyle(fontSize: 16.0, color: model.textColor)),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            height: 50,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedAxis,
                items: _axis.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : '-2 (modified)',
                      child: Text(value,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  _onAxisTypeChange(value.toString());
                  stateSetter(() {});
                }),
          ),
        ],
      );
    });
  }

  /// Returns the spline chart with axis crossing at provided axis value.
  SfCartesianChart _buildAxisCrossingBaseValueSample() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth rate of countries'),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.wrap,
          crossesAt: _crossAt,
          placeLabelsNearAxisLine: false),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          minimum: -2,
          maximum: 2,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on
  /// the bar or column chart with axis crossing.

  List<ChartSeries<ChartSampleData, String>> _getSeries() {
    List<ChartSeries<ChartSampleData, String>> chart;
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Iceland',
          y: 1.13,
          pointColor: const Color.fromRGBO(107, 189, 98, 1)),
      ChartSampleData(
          x: 'Algeria',
          y: 1.7,
          pointColor: const Color.fromRGBO(107, 189, 98, 1)),
      ChartSampleData(
          x: 'Singapore',
          y: 1.82,
          pointColor: const Color.fromRGBO(107, 189, 98, 1)),
      ChartSampleData(
          x: 'Malaysia',
          y: 1.37,
          pointColor: const Color.fromRGBO(107, 189, 98, 1)),
      ChartSampleData(
          x: 'Moldova',
          y: -1.05,
          pointColor: const Color.fromRGBO(199, 86, 86, 1)),
      ChartSampleData(
          x: 'American Samoa',
          y: -1.3,
          pointColor: const Color.fromRGBO(199, 86, 86, 1)),
      ChartSampleData(
          x: 'Latvia',
          y: -1.1,
          pointColor: const Color.fromRGBO(199, 86, 86, 1))
    ];
    chart = <ChartSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          pointColorMapper: (ChartSampleData sales, _) => sales.pointColor,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              alignment: ChartAlignment.center)),
    ];
    return chart;
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
      /// update the axis type changes
    });
  }
}
