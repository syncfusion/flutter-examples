/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  TrackballBehavior? _trackballBehavior;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _period = 14;
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      tooltipSettings: InteractiveTooltip(
        color: model.themeData.colorScheme.brightness == Brightness.light
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
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Period',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                      SizedBox(height: model.isMobile ? 30.0 : 16.0),
                      Text(
                        model.isWebFullView
                            ? 'Standard \ndeviation'
                            : 'Standard deviation',
                        softWrap: false,
                        style: TextStyle(fontSize: 16, color: model.textColor),
                      ),
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomDirectionalButtons(
                        maxValue: 50,
                        initialValue: _period,
                        onChanged: (double val) => setState(() {
                          _period = val;
                        }),
                        loop: true,
                        iconColor: model.textColor,
                        style:
                            TextStyle(fontSize: 20.0, color: model.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      CustomDirectionalButtons(
                        maxValue: 5,
                        initialValue: _standardDeviation,
                        onChanged: (double val) => setState(() {
                          _standardDeviation = val;
                        }),
                        loop: true,
                        iconColor: model.textColor,
                        style:
                            TextStyle(fontSize: 20.0, color: model.textColor),
                      ),
                      const SizedBox(height: 10.0),
                    ])
              ]),
        ),
      ],
    );
  }

  // Returns the OHLC chart with Bollinger band indicator
  SfCartesianChart _buildDefaulBollingerIndicator() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: !isCardView,
      ),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.MMM(),
        interval: 3,
        minimum: DateTime(2016),
        maximum: DateTime(2017),
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
            dataSource: getChartData(),
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
