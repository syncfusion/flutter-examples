/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the spline types cahrt sample.
class SplineTypes extends SampleView {
  /// Creates the spline types cahrt sample.
  const SplineTypes(Key key) : super(key: key);

  @override
  _SplineTypesState createState() => _SplineTypesState();
}

/// State class for spline types chart.
class _SplineTypesState extends SampleViewState {
  _SplineTypesState();

  final List<String> _splineList =
      <String>['natural', 'monotonic', 'cardinal', 'clamped'].toList();
  late String _selectedSplineType;
  late SplineType _spline;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _selectedSplineType = 'natural';
    _spline = SplineType.natural;
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTypesSplineChart();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Spline type ',
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            height: 50,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedSplineType,
                items: _splineList.map((String value) {
                  return DropdownMenuItem<String>(
                      value: (value != null) ? value : 'natural',
                      child: Text(value,
                          style: TextStyle(color: model.textColor)));
                }).toList(),
                onChanged: (dynamic value) {
                  _onPositionTypeChange(value.toString());
                  stateSetter(() {});
                }),
          ),
        ],
      );
    });
  }

  /// Returns the spline types chart.
  SfCartesianChart _buildTypesSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Export growth of Brazil'),
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          minimum: -0.1,
          maximum: 0.2,
          interval: 0.1,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getSplineTypesSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<_ChartData, num>> _getSplineTypesSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(2011, 0.05),
      _ChartData(2011.25, 0),
      _ChartData(2011.50, 0.03),
      _ChartData(2011.75, 0),
      _ChartData(2012, 0.04),
      _ChartData(2012.25, 0.02),
      _ChartData(2012.50, -0.01),
      _ChartData(2012.75, 0.01),
      _ChartData(2013, -0.08),
      _ChartData(2013.25, -0.02),
      _ChartData(2013.50, 0.03),
      _ChartData(2013.75, 0.05),
      _ChartData(2014, 0.04),
      _ChartData(2014.25, 0.02),
      _ChartData(2014.50, 0.04),
      _ChartData(2014.75, 0),
      _ChartData(2015, 0.02),
      _ChartData(2015.25, 0.10),
      _ChartData(2015.50, 0.09),
      _ChartData(2015.75, 0.11),
      _ChartData(2016, 0.12),
    ];
    return <SplineSeries<_ChartData, num>>[
      SplineSeries<_ChartData, num>(

          /// To set the spline type here.
          splineType: _spline,
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2)
    ];
  }

  /// Method to change the spline type using dropdown menu.
  void _onPositionTypeChange(String item) {
    _selectedSplineType = item;
    if (_selectedSplineType == 'natural') {
      _spline = SplineType.natural;
    }
    if (_selectedSplineType == 'monotonic') {
      _spline = SplineType.monotonic;
    }
    if (_selectedSplineType == 'cardinal') {
      _spline = SplineType.cardinal;
    }
    if (_selectedSplineType == 'clamped') {
      _spline = SplineType.clamped;
    }
    setState(() {
      /// update the spline type changes
    });
  }
}

/// Private class for storing the spline series data points.
class _ChartData {
  _ChartData(this.x, this.y);
  final double x;
  final double y;
}
