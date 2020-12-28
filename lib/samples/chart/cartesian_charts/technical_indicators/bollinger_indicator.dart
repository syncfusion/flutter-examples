/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with Bollinger band indicator sample.
class BollingerIndicator extends SampleView {
  /// creates the OHLC chart with Bollinger band indicator.
  const BollingerIndicator(Key key) : super(key: key);

  @override
  _BollingerIndicatorState createState() => _BollingerIndicatorState();
}

/// State class of the OHLC chart with Bollinger band indicator.
class _BollingerIndicatorState extends SampleViewState {
  _BollingerIndicatorState();
  double _period = 14.0;
  double _standardDeviation = 1.0;

  @override
  void initState() {
    _period = 14;
    _standardDeviation = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaulBollingerIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Period',
                style: TextStyle(color: model.textColor),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(125, 0, 0, 0),
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
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Standard deviation',
                style: TextStyle(color: model.textColor),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: CustomDirectionalButtons(
                  maxValue: 5,
                  initialValue: _standardDeviation,
                  onChanged: (double val) => setState(() {
                    _standardDeviation = val;
                  }),
                  loop: true,
                  iconColor: model.textColor,
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Returns the OHLC chart with Bollinger band indicator
  SfCartesianChart _getDefaulBollingerIndicator() {
    final List<ChartSampleData> chartData = getChartData();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: !isCardView,
      ),
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
        tooltipSettings: InteractiveTooltip(
          color: model.themeData.brightness == Brightness.light
              ? Color.fromRGBO(79, 79, 79, 1)
              : Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: isCardView ? true : false),
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// Bollinger band indicator mentioned here.
        BollingerBandIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          animationDuration: 0,
          period: _period.toInt() ?? 14,
          standardDeviation: _standardDeviation.toInt() ?? 1,
        ),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: <ChartSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
            dataSource: chartData,
            opacity: 0.7,
            borderWidth: 2,
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
