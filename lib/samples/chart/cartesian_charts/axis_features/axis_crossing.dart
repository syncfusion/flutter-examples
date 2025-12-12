/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the Spline Chart with axis crossing sample.
class AxisCrossing extends SampleView {
  const AxisCrossing(Key key) : super(key: key);

  @override
  _AxisCrossingState createState() => _AxisCrossingState();
}

/// State class of the Spline Chart with axis crossing.
class _AxisCrossingState extends SampleViewState {
  _AxisCrossingState();

  List<String>? _axis;
  late String _selectedAxis;
  late String _selectedAxisType;
  late double _crossAt = 0;
  bool? _isPlaceLabelsNearAxisLine = true;
  late String _selectedSeriesType;
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _interpolationData;

  @override
  void initState() {
    _axis = <String>['x', 'y'].toList();
    _selectedAxis = 'x';
    _selectedAxisType = 'x';
    _crossAt = 0;
    _isPlaceLabelsNearAxisLine = true;
    _selectedSeriesType = 'column';
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _interpolationData = <ChartSampleData>[
      ChartSampleData(x: -7, y: -3),
      ChartSampleData(x: -4.5, y: -2),
      ChartSampleData(x: -3.5, y: 0),
      ChartSampleData(x: -3, y: 2),
      ChartSampleData(x: 0, y: 7),
      ChartSampleData(x: 3, y: 2),
      ChartSampleData(x: 3.5, y: 0),
      ChartSampleData(x: 4.5, y: -2),
      ChartSampleData(x: 7, y: -3),
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
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Axis  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(138, 0, 20, 0),
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _selectedAxis,
                    items: _axis!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'X',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      _onAxisTypeChange(value.toString());
                      stateSetter(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Cross at  ',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                CustomDirectionalButtons(
                  minValue: -8,
                  maxValue: 8,
                  initialValue: _crossAt,
                  onChanged: (double val) => setState(() {
                    _crossAt = val;
                  }),
                  step: 2,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 20.0, color: model.textColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Labels near axis line',
                  style: TextStyle(color: model.textColor, fontSize: 16),
                ),
                SizedBox(
                  width: 75,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: model.primaryColor,
                    value: _isPlaceLabelsNearAxisLine,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPlaceLabelsNearAxisLine = value;
                        stateSetter(() {});
                      });
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

  /// Return the Cartesian Chart with Spline series
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Spline Interpolation'),
      primaryXAxis: NumericAxis(
        minimum: -8,
        maximum: 8,
        interval: 2,
        placeLabelsNearAxisLine: isCardView
            ? true
            : _selectedAxisType == 'x'
            ? _isPlaceLabelsNearAxisLine ?? true
            : true,
        crossesAt: _selectedAxisType == 'x' ? _crossAt : 0,
        minorTicksPerInterval: 3,
      ),
      primaryYAxis: NumericAxis(
        minimum: -8,
        maximum: 8,
        interval: 2,
        placeLabelsNearAxisLine: isCardView
            ? true
            : _selectedAxisType == 'y'
            ? _isPlaceLabelsNearAxisLine ?? true
            : true,
        crossesAt: _selectedAxisType == 'y' ? _crossAt : 0,
        minorTicksPerInterval: 3,
      ),
      series: _buildSplineSeries(_selectedSeriesType),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<CartesianSeries<ChartSampleData, num>> _buildSplineSeries(
    String seriesType,
  ) {
    return <CartesianSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        dataSource: _interpolationData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        color: const Color.fromRGBO(20, 122, 20, 1),
        name: 'Cubic Interpolation',
      ),
    ];
  }

  /// Method for updating the axis type on change.
  void _onAxisTypeChange(String item) {
    _selectedAxis = item;
    if (_selectedAxis == 'x') {
      _selectedAxisType = 'x';
    } else if (_selectedAxis == 'y') {
      _selectedAxisType = 'y';
    }
    setState(() {
      /// Update the axis type changes.
    });
  }

  @override
  void dispose() {
    _axis!.clear();
    _interpolationData!.clear();
    super.dispose();
  }
}
