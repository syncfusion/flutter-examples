/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart  with Stochastic indicator sample.
class StochasticcIndicator extends SampleView {
  /// creates the OHLC chart  with Stochastic indicator.
  const StochasticcIndicator(Key key) : super(key: key);

  @override
  _StochasticcIndicatorState createState() => _StochasticcIndicatorState();
}

/// State class of the OHLC chart  with Stochastic indicator.
class _StochasticcIndicatorState extends SampleViewState {
  _StochasticcIndicatorState();
  double _period = 14.0;
  double _kPeriod = 3.0;
  double _dPeriod = 5.0;
  double _overBought = 80.0;
  double _overSold = 20.0;
  bool _showZones = true;

  @override
  void initState() {
    _period = 14.0;
    _overBought = 80.0;
    _overSold = 20.0;
    _kPeriod = 3.0;
    _dPeriod = 5.0;
    _showZones = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaultStochasticIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
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
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(82, 0, 0, 0),
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
                  'K Period',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(68, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 100,
                    initialValue: _kPeriod,
                    onChanged: (double val) => setState(() {
                      _kPeriod = val;
                    }),
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
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
                  'D Period',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(68, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 50,
                    initialValue: _dPeriod,
                    onChanged: (double val) => setState(() {
                      _dPeriod = val;
                    }),
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
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
                  'Overbought',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(46, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 100,
                    initialValue: _overBought,
                    onChanged: (double val) => setState(() {
                      _overBought = val;
                    }),
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Oversold',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(65, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 50,
                    initialValue: _overSold,
                    onChanged: (double val) => setState(() {
                      _overSold = val;
                    }),
                    loop: true,
                    iconColor: model.textColor,
                    style: TextStyle(fontSize: 20.0, color: model.textColor),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Show zones',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Container(
                        width: 90,
                        child: CheckboxListTile(
                            activeColor: model.backgroundColor,
                            value: _showZones,
                            onChanged: (bool value) {
                              setState(() {
                                _showZones = value;
                                stateSetter(() {});
                              });
                            }))),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the OHLC chart  with Stochastic indicator.
  SfCartesianChart _getDefaultStochasticIndicator() {
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
      axes: <ChartAxis>[
        NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            opposedPosition: true,
            name: 'yaxes',
            minimum: 10,
            maximum: 110,
            interval: 20,
            axisLine: AxisLine(width: 0))
      ],
      trackballBehavior: TrackballBehavior(
        enable: !isCardView,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      tooltipBehavior: TooltipBehavior(enable: isCardView ? true : false),
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// Stochastic indicator mentioned here.
        StochasticIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yaxes',
          overbought: _overBought ?? 80,
          oversold: _overSold ?? 20,
          showZones: _showZones ?? true,
          period: _period.toInt() ?? 14,
          kPeriod: _kPeriod.toInt() ?? 3,
          dPeriod: _dPeriod.toInt() ?? 5,
        ),
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
