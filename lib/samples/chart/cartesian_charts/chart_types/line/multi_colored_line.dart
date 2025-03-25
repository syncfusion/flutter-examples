/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders Line series with point color mapping.
class LineMultiColor extends SampleView {
  const LineMultiColor(Key key) : super(key: key);

  @override
  _LineMultiColorState createState() => _LineMultiColorState();
}

class _LineMultiColorState extends SampleViewState {
  _LineMultiColorState();

  TrackballBehavior? _trackballBehavior;
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
    );
    _chartData = <_ChartData>[
      _ChartData(DateTime(1925), 415, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1926), 408, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1927), 415, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1928), 350, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1929), 375, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1930), 500, const Color.fromRGBO(248, 184, 131, 1)),
      _ChartData(DateTime(1931), 390, const Color.fromRGBO(229, 101, 144, 1)),
      _ChartData(DateTime(1932), 450, const Color.fromRGBO(229, 101, 144, 1)),
      _ChartData(DateTime(1933), 440, const Color.fromRGBO(229, 101, 144, 1)),
      _ChartData(DateTime(1934), 350, const Color.fromRGBO(229, 101, 144, 1)),
      _ChartData(DateTime(1935), 400, const Color.fromRGBO(229, 101, 144, 1)),
      _ChartData(DateTime(1936), 365, const Color.fromRGBO(53, 124, 210, 1)),
      _ChartData(DateTime(1937), 490, const Color.fromRGBO(53, 124, 210, 1)),
      _ChartData(DateTime(1938), 400, const Color.fromRGBO(53, 124, 210, 1)),
      _ChartData(DateTime(1939), 520, const Color.fromRGBO(53, 124, 210, 1)),
      _ChartData(DateTime(1940), 510, const Color.fromRGBO(53, 124, 210, 1)),
      _ChartData(DateTime(1941), 395, const Color.fromRGBO(0, 189, 174, 1)),
      _ChartData(DateTime(1942), 380, const Color.fromRGBO(0, 189, 174, 1)),
      _ChartData(DateTime(1943), 404, const Color.fromRGBO(0, 189, 174, 1)),
      _ChartData(DateTime(1944), 400, const Color.fromRGBO(0, 189, 174, 1)),
      _ChartData(DateTime(1945), 500, const Color.fromRGBO(0, 189, 174, 1)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Annual rainfall of Paris'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: const MajorGridLines(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'Year'),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 200,
        maximum: 600,
        interval: 100,
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}mm',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, DateTime>> _buildLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,

        /// The property used to apply the color each data.
        pointColorMapper: (_ChartData sales, int index) => sales.lineColor,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, [this.lineColor]);
  final DateTime x;
  final double y;
  final Color? lineColor;
}
