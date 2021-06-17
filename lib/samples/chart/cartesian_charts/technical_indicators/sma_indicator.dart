/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with Simple moving average indicator sample.
class SMAIndicator extends SampleView {
  /// Creates the OHLC chart with Simple moving average indicator.
  const SMAIndicator(Key key) : super(key: key);

  @override
  _SMAIndicatorState createState() => _SMAIndicatorState();
}

/// State class of the OHLC chart with Simple moving average indicator.
class _SMAIndicatorState extends SampleViewState {
  _SMAIndicatorState();
  late double _period;
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _period = 14;
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _tooltipBehavior = TooltipBehavior(enable: isCardView ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaulSMAIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Period',
          style: TextStyle(color: model.textColor),
        ),
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
        )
      ],
    );
  }

  /// Returns the OHLC chart with Simple moving average indicator.
  SfCartesianChart _buildDefaulSMAIndicator() {
    final List<ChartSampleData> chartData = getChartData();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.MMM(),
        interval: 3,
        minimum: DateTime(2016, 01, 01),
        maximum: DateTime(2017, 01, 01),
      ),
      primaryYAxis: NumericAxis(
          minimum: 70,
          maximum: 130,
          interval: 20,
          labelFormat: r'${value}',
          axisLine: const AxisLine(width: 0)),
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: _tooltipBehavior,
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// SMA indicator mentioned here.
        SmaIndicator<ChartSampleData, DateTime>(
            seriesName: 'AAPL', period: _period.toInt()),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: <ChartSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
            dataSource: chartData,
            opacity: 0.7,
            xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            name: 'AAPL'),
      ],
    );
  }
}
