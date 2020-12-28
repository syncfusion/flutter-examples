/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with
/// Moving average convergence divergence indicator sample.
class MACDIndicator extends SampleView {
  /// creates the OHLC chart with MACD indicator.
  const MACDIndicator(Key key) : super(key: key);

  @override
  _MACDIndicatorState createState() => _MACDIndicatorState();
}

/// State class of the OHLC chart with
/// Moving average convergence divergence indicator.
class _MACDIndicatorState extends SampleViewState {
  _MACDIndicatorState();
  double _period = 14.0;
  double _longPeriod = 5.0;
  double _shortPeriod = 2.0;
  final List<String> _macdIndicatorTypeList =
      <String>['Both', 'Line', 'Histogram'].toList();
  String _selectedMacdIndicatorType = 'Both';
  MacdType _macdType = MacdType.both;

  @override
  void initState() {
    _period = 14;
    _longPeriod = 5.0;
    _shortPeriod = 2.0;
    _selectedMacdIndicatorType = 'Both';
    _macdType = MacdType.both;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaultMACDIndicator();
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
                  padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
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
                  'Long Period',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 50,
                    initialValue: _longPeriod,
                    onChanged: (double val) => setState(() {
                      _longPeriod = val;
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
                  'Short period',
                  style: TextStyle(fontSize: 16.0, color: model.textColor),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                  child: CustomDirectionalButtons(
                    maxValue: 50,
                    initialValue: _shortPeriod,
                    onChanged: (double val) => setState(() {
                      _shortPeriod = val;
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
                Text('MACD type      ',
                    style: TextStyle(
                      color: model.textColor,
                      fontSize: 16,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(34, 0, 0, 0),
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  child: DropdownButton<String>(
                      underline: Container(color: Color(0xFFBDBDBD), height: 1),
                      value: _selectedMacdIndicatorType,
                      items: _macdIndicatorTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                            value: (value != null) ? value : 'Both',
                            child: Text('$value',
                                style: TextStyle(color: model.textColor)));
                      }).toList(),
                      onChanged: (String value) {
                        _onMacdIndicatorTypeChanged(value.toString());
                        stateSetter(() {});
                      }),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// Returns the OHLC chart with
  /// Moving average convergence divergence indicator.
  SfCartesianChart _getDefaultMACDIndicator() {
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
          axisLine: AxisLine(width: 0)),
      axes: <ChartAxis>[
        NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
            opposedPosition: true,
            name: 'agybrd',
            interval: 2)
      ],
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// MACD indicator mentioned here.
        MacdIndicator<ChartSampleData, DateTime>(
            period: _period.toInt() ?? 14,
            longPeriod: _longPeriod.toInt() ?? 5,
            shortPeriod: _shortPeriod.toInt() ?? 2,
            signalLineWidth: 2,
            macdType: _macdType,
            seriesName: 'AAPL',
            yAxisName: 'agybrd'),
      ],
      trackballBehavior: TrackballBehavior(
        enable: !isCardView,
        activationMode: ActivationMode.singleTap,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      ),
      tooltipBehavior: TooltipBehavior(enable: isCardView ? true : false),
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

  /// Method for updating the Macd indicator type in the cahrt on change.
  void _onMacdIndicatorTypeChanged(String item) {
    _selectedMacdIndicatorType = item;
    switch (_selectedMacdIndicatorType) {
      case 'Both':
        _macdType = MacdType.both;
        break;
      case 'Line':
        _macdType = MacdType.line;
        break;
      case 'Histogram':
        _macdType = MacdType.histogram;
        break;
    }
    setState(() {
      /// update the MACD type changes
    });
  }
}
