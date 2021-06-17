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
  late double _period;
  late double _longPeriod;
  late double _shortPeriod;
  final List<String> _macdIndicatorTypeList =
      <String>['Both', 'Line', 'Histogram'].toList();
  late String _selectedMacdIndicatorType = 'Both';
  late MacdType _macdType = MacdType.both;
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _period = 14;
    _longPeriod = 5.0;
    _shortPeriod = 2.0;
    _selectedMacdIndicatorType = 'Both';
    _macdType = MacdType.both;
    _trackballBehavior = TrackballBehavior(
      enable: !isCardView,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
    _tooltipBehavior = TooltipBehavior(enable: isCardView ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultMACDIndicator();
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
              'Long Period',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
            ),
          ),
          ListTile(
            title: Text(
              'Short period',
              style: TextStyle(color: model.textColor),
            ),
            trailing: Container(
              width: 0.5 * screenWidth,
              padding: EdgeInsets.only(left: 0.03 * screenWidth),
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
            ),
          ),
          ListTile(
            title: Text('MACD type      ',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.5 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _selectedMacdIndicatorType,
                  items: _macdIndicatorTypeList.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'Both',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (String? value) {
                    _onMacdIndicatorTypeChanged(value.toString());
                    stateSetter(() {});
                  }),
            ),
          ),
        ],
      );
    });
  }

  /// Returns the OHLC chart with
  /// Moving average convergence divergence indicator.
  SfCartesianChart _buildDefaultMACDIndicator() {
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
          axisLine: const AxisLine(width: 0)),
      axes: <ChartAxis>[
        NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            opposedPosition: true,
            name: 'agybrd',
            interval: 2)
      ],
      indicators: <TechnicalIndicators<ChartSampleData, DateTime>>[
        /// MACD indicator mentioned here.
        MacdIndicator<ChartSampleData, DateTime>(
            period: _period.toInt(),
            longPeriod: _longPeriod.toInt(),
            shortPeriod: _shortPeriod.toInt(),
            signalLineWidth: 2,
            macdType: _macdType,
            seriesName: 'AAPL',
            yAxisName: 'agybrd'),
      ],
      trackballBehavior: _trackballBehavior,
      tooltipBehavior: _tooltipBehavior,
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
