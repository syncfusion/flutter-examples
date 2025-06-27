/// Dart import.
import 'dart:convert';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the default line series chart using Json data.
class JsonData extends SampleView {
  /// Creates the default line series chart using Json data.
  const JsonData(Key key) : super(key: key);

  @override
  _JsonDataState createState() => _JsonDataState();
}

/// State class for the default line series chart using Json data.
class _JsonDataState extends SampleViewState {
  _JsonDataState();
  TrackballBehavior? _trackballBehavior;
  List<_SampleData>? _chartData;
  GlobalKey<SfCartesianChartState>? _chartKey;

  /// Method to load Json file from assets.
  Future<String> _loadJsonDataAsset() async {
    return rootBundle.loadString('assets/chart_data.json');
  }

  /// Method to handle deserialization steps.
  // ignore: always_specify_types, strict_raw_type
  Future _loadJsonChartData() async {
    final String jsonString =
        await _loadJsonDataAsset(); // Deserialization  step 1.
    final dynamic jsonResponse = json.decode(
      jsonString,
    ); // Deserialization  step 2.
    setState(() {
      // ignore: always_specify_types
      for (final Map<dynamic, dynamic> i in jsonResponse) {
        _chartData!.add(_SampleData.fromJson(i)); // Deserialization step 3.
      }
      _chartKey = GlobalKey<SfCartesianChartState>();
    });
  }

  @override
  void initState() {
    super.initState();
    _chartData = <_SampleData>[];
    _loadJsonChartData();
    _trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: model.themeData.colorScheme.brightness == Brightness.dark
          ? const Color.fromRGBO(255, 255, 255, 0.03)
          : const Color.fromRGBO(0, 0, 0, 0.03),
      lineWidth: 15,
      activationMode: ActivationMode.singleTap,
      markerSettings: const TrackballMarkerSettings(
        borderWidth: 4,
        height: 10,
        width: 10,
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultLineChart();
  }

  /// Returns the cartesian chart with default line series.
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      key: _chartKey,
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison'),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        name: 'Years',
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        name: 'Price',
        minimum: 70,
        maximum: 110,
        interval: 10,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _buildDefaultLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<_SampleData, DateTime>> _buildDefaultLineSeries() {
    return <LineSeries<_SampleData, DateTime>>[
      LineSeries<_SampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_SampleData data, int index) => data.x,
        yValueMapper: (_SampleData data, int index) => data.y1,
        name: 'Product A',
      ),
      LineSeries<_SampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_SampleData data, int index) => data.x,
        yValueMapper: (_SampleData data, int index) => data.y2,
        name: 'Product B',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _SampleData {
  _SampleData(this.x, this.y1, this.y2);
  factory _SampleData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return _SampleData(
      DateTime.parse(parsedJson['x']),
      parsedJson['y1'],
      parsedJson['y2'],
    );
  }
  DateTime x;
  num y1;
  num y2;
}
