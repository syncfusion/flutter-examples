/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with Weighted moving average indicator.
class WMAIndicator extends SampleView {
  /// creates the OHLC chart with Weighted moving average indicator.
  const WMAIndicator(Key key) : super(key: key);

  @override
  _WMAIndicatorState createState() => _WMAIndicatorState();
}

/// State class of the OHLC chart with Weighted moving average indicator.
class _WMAIndicatorState extends SampleViewState {
  _WMAIndicatorState();
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
    return _buildDefaultWMAIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
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

  /// Returns the the OHLC chart with Weighted moving average indicator.
  SfCartesianChart _buildDefaultWMAIndicator() {
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
      trackballBehavior: _trackballBehavior,
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// WMA indicator for the 'AAPL' series.
        WmaIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
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
