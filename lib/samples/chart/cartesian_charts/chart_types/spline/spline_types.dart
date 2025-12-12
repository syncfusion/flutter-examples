/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Spline types Chart sample.
class SplineTypes extends SampleView {
  const SplineTypes(Key key) : super(key: key);

  @override
  _SplineTypesState createState() => _SplineTypesState();
}

/// State class for Spline types Chart.
class _SplineTypesState extends SampleViewState {
  _SplineTypesState();

  late String _selectedSplineType;
  List<String>? _splineList;
  SplineType? _spline;
  TooltipBehavior? _tooltipBehavior;
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _selectedSplineType = 'natural';
    _splineList = <String>[
      'natural',
      'monotonic',
      'cardinal',
      'clamped',
    ].toList();
    _spline = SplineType.natural;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <_ChartData>[
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
          children: <Widget>[
            Text(
              'Spline type ',
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                dropdownColor: model.drawerBackgroundColor,
                focusColor: Colors.transparent,
                underline: Container(color: const Color(0xFFBDBDBD), height: 1),
                value: _selectedSplineType,
                items: _splineList!.map((String value) {
                  return DropdownMenuItem<String>(
                    value: (value != null) ? value : 'natural',
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
        );
      },
    );
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Export growth of Brazil'),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}%',
        minimum: -0.1,
        maximum: 0.2,
        interval: 0.1,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineSeries<_ChartData, num>> _buildSplineSeries() {
    return <SplineSeries<_ChartData, num>>[
      SplineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,

        /// To set the Spline type here.
        splineType: _spline!,
      ),
    ];
  }

  /// Method to change the Spline type using dropdown menu.
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
      /// Update the Spline type changes.
    });
  }

  @override
  void dispose() {
    _splineList!.clear();
    _chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the Spline series data points.
class _ChartData {
  _ChartData(this.x, this.y);
  final double x;
  final double y;
}
