/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC series chart with Accumulation
/// distribution indicator samples.
class AdIndicator extends SampleView {
  /// creates the OHLC series chart with Accumulation
  /// distribution indicator.
  const AdIndicator(Key key) : super(key: key);

  @override
  _AdIndicatorState createState() => _AdIndicatorState();
}

/// State class for the OHLC series chart with Accumulation
/// distribution indicator.
class _AdIndicatorState extends SampleViewState {
  _AdIndicatorState();
  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultAdIndicator();
  }

  /// Returns a cartesian OHLC chart with Accumulation
  /// distribution indicator.
  SfCartesianChart _buildDefaultAdIndicator() {
    return SfCartesianChart(
      legend: Legend(isVisible: !isCardView),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.MMM(),
        interval: 3,
        minimum: DateTime(2016),
        maximum: DateTime(2017),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 70,
        maximum: 130,
        interval: 20,
        labelFormat: r'${value}',
        axisLine: AxisLine(width: 0),
      ),
      axes: <ChartAxis>[
        NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yAxis',
          minimum: -5000000000,
          maximum: 5000000000,
          interval: 2500000000,
          numberFormat: NumberFormat.compact(),
        ),
      ],
      trackballBehavior: _trackballBehavior,
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// Accumulation Distribution Indicator for the 'AAPL' series.
        AccumulationDistributionIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yAxis',
        ),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: _buildHiloOpenCloseSeries(),
    );
  }

  /// Returns the cartesian hilo open close series.
  List<CartesianSeries<ChartSampleData, DateTime>> _buildHiloOpenCloseSeries() {
    return <CartesianSeries<ChartSampleData, DateTime>>[
      HiloOpenCloseSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        lowValueMapper: (ChartSampleData data, int index) => data.low,
        highValueMapper: (ChartSampleData data, int index) => data.high,
        openValueMapper: (ChartSampleData data, int index) => data.open,
        closeValueMapper: (ChartSampleData data, int index) => data.close,
        volumeValueMapper: (ChartSampleData data, int index) => data.volume,
        name: 'AAPL',
        opacity: 0.7,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
