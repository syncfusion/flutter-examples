/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC series chart with Momentum indicator sample.
class MomentummIndicator extends SampleView {
  /// creates the OHLC series chart with Momentum indicator.
  const MomentummIndicator(Key key) : super(key: key);

  @override
  _MomentummIndicatorState createState() => _MomentummIndicatorState();
}

/// State class for the OHLC series chart with Momentum indicator.
class _MomentummIndicatorState extends SampleViewState {
  _MomentummIndicatorState();
  late double _period;
  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    super.initState();
    _period = 14;
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultMomentumIndicator();
  }

  @override
  Widget buildSettings(BuildContext c0ntext) {
    return Row(
      children: <Widget>[
        Text('Period', style: TextStyle(color: model.textColor)),
        Container(
          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: CustomDirectionalButtons(
            maxValue: 50,
            initialValue: _period,
            onChanged: (double val) => setState(() {
              _period = val;
            }),
            loop: true,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian OHLC series chart with Momentum indicator.
  SfCartesianChart _buildDefaultMomentumIndicator() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
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
      axes: const <ChartAxis>[
        NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yAxis',
          minimum: 50,
          maximum: 150,
          interval: 20,
          axisLine: AxisLine(width: 0),
        ),
      ],
      trackballBehavior: _trackballBehavior,
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// Momentum indicator for the 'AAPL' series.
        MomentumIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yAxis',
          period: _period.toInt(),
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
