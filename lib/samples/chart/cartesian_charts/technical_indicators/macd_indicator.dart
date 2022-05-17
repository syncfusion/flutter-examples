/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<String>? _macdIndicatorTypeList;
  late String _selectedMacdIndicatorType;
  late MacdType _macdType = MacdType.both;
  TrackballBehavior? _trackballBehavior;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _period = 14;
    _longPeriod = 5.0;
    _shortPeriod = 2.0;
    _selectedMacdIndicatorType = 'both';
    _macdType = MacdType.both;
    _macdIndicatorTypeList = <String>['both', 'line', 'histogram'].toList();
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
    final double dropDownWidth = 0.7 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
              Expanded(
                flex: 14,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text(
                            'Period',
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 16, color: model.textColor),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: SizedBox(
                            width: dropDownWidth,
                            child: CustomDirectionalButtons(
                              maxValue: 50,
                              initialValue: _period,
                              onChanged: (double val) => setState(() {
                                _period = val;
                              }),
                              loop: true,
                              iconColor: model.textColor,
                              style: TextStyle(
                                  fontSize: 20.0, color: model.textColor),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text(
                            model.isWebFullView
                                ? 'Long \nperiod'
                                : 'Long period',
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 16, color: model.textColor),
                          ),
                        ),
                        Flexible(
                            flex: 4,
                            child: CustomDirectionalButtons(
                              maxValue: 50,
                              initialValue: _longPeriod,
                              onChanged: (double val) => setState(() {
                                _longPeriod = val;
                              }),
                              loop: true,
                              iconColor: model.textColor,
                              style: TextStyle(
                                  fontSize: 20.0, color: model.textColor),
                            ))
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Text(
                            model.isWebFullView
                                ? 'Short \nperiod'
                                : 'Short period',
                            softWrap: false,
                            style:
                                TextStyle(fontSize: 16, color: model.textColor),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: CustomDirectionalButtons(
                            maxValue: 50,
                            initialValue: _shortPeriod,
                            onChanged: (double val) => setState(() {
                              _shortPeriod = val;
                            }),
                            loop: true,
                            iconColor: model.textColor,
                            style: TextStyle(
                                fontSize: 20.0, color: model.textColor),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text('MACD type',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16,
                                color: model.textColor,
                              )),
                        ),
                        Flexible(
                          child: DropdownButton<String>(
                              focusColor: Colors.transparent,
                              isExpanded: true,
                              underline: Container(
                                  color: const Color(0xFFBDBDBD), height: 1),
                              value: _selectedMacdIndicatorType,
                              items:
                                  _macdIndicatorTypeList!.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: (value != null) ? value : 'Both',
                                    child: Text(value,
                                        style:
                                            TextStyle(color: model.textColor)));
                              }).toList(),
                              onChanged: (String? value) {
                                _onMacdIndicatorTypeChanged(value.toString());
                                stateSetter(() {});
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
            ],
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _macdIndicatorTypeList!.clear();
    super.dispose();
  }

  /// Returns the OHLC chart with
  /// Moving average convergence divergence indicator.
  SfCartesianChart _buildDefaultMACDIndicator() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView),
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
            dataSource: getChartData(),
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
      case 'both':
        _macdType = MacdType.both;
        break;
      case 'line':
        _macdType = MacdType.line;
        break;
      case 'histogram':
        _macdType = MacdType.histogram;
        break;
    }
    setState(() {
      /// update the MACD type changes
    });
  }
}
