/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';
import 'indicator_data_source.dart';

/// Renders thec OHLC chart with Triangular moving average indicator sample.
class TMAIndicator extends SampleView {
  /// Creates thec OHLC chart with Triangular moving average indicator sample.
  const TMAIndicator(Key key) : super(key: key);

  @override
  _TMAIndicatorState createState() => _TMAIndicatorState();
}

/// State class of the OHLC chart with Triangular moving average indicator.
class _TMAIndicatorState extends SampleViewState {
  _TMAIndicatorState();
  double _period = 14.0;

  @override
  void initState() {
    _period = 14;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaulTMAIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Period',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
                      maxValue: 50,
                      initialValue: _period,
                      onChanged: (double val) => setState(() {
                        _period = val;
                      }),
                      step: 1,
                      loop: true,
                      padding: 0,
                      iconColor: model.textColor,
                      style: TextStyle(fontSize: 20.0, color: model.textColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the OHLC chart with Triangular moving average indicator.
  SfCartesianChart _getDefaulTMAIndicator() {
    final List<ChartSampleData> chartData = getChartData();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        dateFormat: DateFormat.MMM(),
        interval: 3,
        minimum: DateTime(2016, 01, 01),
        maximum: DateTime(2017, 01, 01),
      ),
      primaryYAxis: NumericAxis(
          minimum: 70,
          maximum: 130,
          interval: 20,
          labelFormat: '\${value}',
          axisLine: AxisLine(width: 0)),
      trackballBehavior: TrackballBehavior(
        enable: !isCardView,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      tooltipBehavior: TooltipBehavior(enable: isCardView ? true : false),
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// TMA indicator mentioned here.
        TmaIndicator<ChartSampleData, DateTime>(
            seriesName: 'AAPL', period: _period.toInt() ?? 14),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: <ChartSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
            dataSource: chartData,
            opacity: 0.7,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            lowValueMapper: (ChartSampleData sales, _) => sales.low,
            highValueMapper: (ChartSampleData sales, _) => sales.high,
            openValueMapper: (ChartSampleData sales, _) => sales.open,
            closeValueMapper: (ChartSampleData sales, _) => sales.close,
            name: 'AAPL'),
      ],
    );
  }
}
