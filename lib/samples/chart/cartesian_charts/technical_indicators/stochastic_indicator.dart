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
  late double _period;
  late double _kPeriod;
  late double _dPeriod;
  late double _overBought;
  late double _overSold;
  late bool _showZones;
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _period = 14.0;
    _overBought = 80.0;
    _overSold = 20.0;
    _kPeriod = 3.0;
    _dPeriod = 5.0;
    _showZones = true;
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _tooltipBehavior = TooltipBehavior(enable: isCardView ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultStochasticIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
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
              'K Period',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
            ),
          ),
          ListTile(
            title: Text(
              'D Period',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
            ),
          ),
          ListTile(
            title: Text(
              'Overbought',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
          ),
          ListTile(
            title: Text(
              'Oversold',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
            ),
          ),
          ListTile(
              title: Text('Show zones',
                  style: TextStyle(
                    color: model.textColor,
                  )),
              trailing: Container(
                  padding: EdgeInsets.only(left: 0.05 * screenWidth),
                  width: 0.5 * screenWidth,
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: model.backgroundColor,
                      value: _showZones,
                      onChanged: (bool? value) {
                        setState(() {
                          _showZones = value!;
                          stateSetter(() {});
                        });
                      }))),
        ],
      );
    });
  }

  /// Returns the OHLC chart  with Stochastic indicator.
  SfCartesianChart _buildDefaultStochasticIndicator() {
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
      axes: <ChartAxis>[
        NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            name: 'yaxes',
            minimum: 10,
            maximum: 110,
            interval: 20,
            axisLine: const AxisLine(width: 0))
      ],
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: _tooltipBehavior,
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// Stochastic indicator mentioned here.
        StochasticIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yaxes',
          overbought: _overBought,
          oversold: _overSold,
          showZones: _showZones,
          period: _period.toInt(),
          kPeriod: _kPeriod.toInt(),
          dPeriod: _dPeriod.toInt(),
        ),
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
