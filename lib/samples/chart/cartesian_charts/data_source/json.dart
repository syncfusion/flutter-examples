///Dart import
import 'dart:convert';

/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

///Renders default line series chart
class JsonData extends SampleView {
  ///Creates default line series chart
  const JsonData(Key key) : super(key: key);

  @override
  _JsonDataState createState() => _JsonDataState();
}

class _JsonDataState extends SampleViewState {
  _JsonDataState();
  late TrackballBehavior _trackballBehavior;

  List<_SampleData> chartData = <_SampleData>[];

  // Method to load Json file from assets.
  Future<String> _loadSalesDataAsset() async {
    return await rootBundle.loadString('assets/chart_data.json');
  }

// Method to hanlde deserialization steps.
  // ignore: always_specify_types
  Future loadSalesData() async {
    final String jsonString =
        await _loadSalesDataAsset(); // Deserialization  step 1
    final dynamic jsonResponse =
        json.decode(jsonString); // Deserialization  step 2
    setState(() {
      // ignore: always_specify_types
      for (final Map i in jsonResponse) {
        chartData.add(_SampleData.fromJson(i)); // Deserialization step 3
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSalesData();
    _trackballBehavior = TrackballBehavior(
        enable: true,
        lineColor: model.themeData.brightness == Brightness.dark
            ? const Color.fromRGBO(255, 255, 255, 0.03)
            : const Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 15,
        activationMode: ActivationMode.singleTap,
        markerSettings: TrackballMarkerSettings(
            borderWidth: 4,
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible));
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultLineChart();
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      key: GlobalKey(),
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison'),
      legend: Legend(
          isVisible: isCardView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          name: 'Years',
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.none,
          name: 'Price',
          minimum: 70,
          maximum: 110,
          interval: 10,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<_SampleData, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<_SampleData, DateTime>>[
      LineSeries<_SampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_SampleData sales, _) => sales.x,
        yValueMapper: (_SampleData sales, _) => sales.y1,
        name: 'Product A',
      ),
      LineSeries<_SampleData, DateTime>(
        dataSource: chartData,
        name: 'Product B',
        xValueMapper: (_SampleData sales, _) => sales.x,
        yValueMapper: (_SampleData sales, _) => sales.y2,
      )
    ];
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
