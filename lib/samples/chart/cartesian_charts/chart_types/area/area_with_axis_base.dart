/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Spline Chart with axis crossing sample.
class AreaAxisCrossingBaseValue extends SampleView {
  const AreaAxisCrossingBaseValue(Key key) : super(key: key);

  @override
  _AxisCrossingBaseValueState createState() => _AxisCrossingBaseValueState();
}

/// State class of the Spline Chart with axis crossing.
class _AxisCrossingBaseValueState extends SampleViewState {
  _AxisCrossingBaseValueState();

  //ignore: unused_field
  late String _selectedAxisType;
  late String _selectedAxis;
  late double _crossAt;
  List<String>? _axis;
  TooltipBehavior? _tooltipBehavior;

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
              focusColor: Colors.transparent,
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

  /// Return the Cartesian Chart with Area series.
  SfCartesianChart _buildCartesianChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      title: ChartTitle(
        text: isCardView ? '' : 'Population growth rate of countries',
      ),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: model.isWebFullView
            ? EdgeLabelPlacement.shift
            : EdgeLabelPlacement.none,
        labelIntersectAction: !isCardView
            ? AxisLabelIntersectAction.rotate45
            : AxisLabelIntersectAction.wrap,
        crossesAt: _crossAt,
        placeLabelsNearAxisLine: false,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        minimum: -2,
        maximum: 3,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Area series.
  List<CartesianSeries<ChartSampleData, String>> _buildAreaSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    return <CartesianSeries<ChartSampleData, String>>[
      AreaSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Iceland', y: 1.13),
          ChartSampleData(x: 'Algeria', y: 1.7),
          ChartSampleData(x: 'Singapore', y: 1.82),
          ChartSampleData(x: 'Malaysia', y: 1.37),
          ChartSampleData(x: 'Moldova', y: -1.05),
          ChartSampleData(x: 'American Samoa', y: -1.3),
          ChartSampleData(x: 'Latvia', y: -1.1),
        ],
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        color: color.withValues(alpha: 0.6),
        borderColor: color,
        markerSettings: const MarkerSettings(isVisible: true),
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
    super.dispose();
  }
}
