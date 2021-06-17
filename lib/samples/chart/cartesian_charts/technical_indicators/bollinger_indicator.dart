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
  late double _period;
  late double _standardDeviation;
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
      tooltipSettings: InteractiveTooltip(
        color: model.themeData.brightness == Brightness.light
            ? const Color.fromRGBO(79, 79, 79, 1)
            : const Color.fromRGBO(255, 255, 255, 1),
      ),
    );
    _tooltipBehavior = TooltipBehavior(enable: isCardView ? true : false);
    _standardDeviation = 1;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaulBollingerIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text(
            'Period',
            style: TextStyle(color: model.textColor),
          ),
          trailing: Container(
            width: 0.5 * screenWidth,
            padding: EdgeInsets.only(left: 0.03 * screenWidth),
            child: CustomDirectionalButtons(
              maxValue: 50,
              initialValue: _period,
              onChanged: (double val) => setState(() {
                _period = val;
              }),
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 20.0, color: model.textColor),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Standard deviation',
            style: TextStyle(color: model.textColor),
          ),
          trailing: Container(
            width: 0.5 * screenWidth,
            padding: EdgeInsets.only(left: 0.03 * screenWidth),
            child: CustomDirectionalButtons(
              maxValue: 5,
              initialValue: _standardDeviation,
              onChanged: (double val) => setState(() {
                _standardDeviation = val;
              }),
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 20.0, color: model.textColor),
            ),
          ),
        ),
      ],
    );
  }

  // Returns the OHLC chart with Bollinger band indicator
  SfCartesianChart _buildDefaulBollingerIndicator() {
    final List<ChartSampleData> chartData = getChartData();
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: !isCardView,
      ),
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
        /// Bollinger band indicator mentioned here.
        BollingerBandIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          animationDuration: 0,
          period: _period.toInt(),
          standardDeviation: _standardDeviation.toInt(),
        ),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: <ChartSeries<ChartSampleData, DateTime>>[
        HiloOpenCloseSeries<ChartSampleData, DateTime>(
            emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
            dataSource: chartData,
            opacity: 0.7,
            borderWidth: 2,
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
