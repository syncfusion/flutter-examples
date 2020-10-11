/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../../widgets/checkbox.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/shared/mobile.dart'
    if (dart.library.html) '../../../../widgets/shared/web.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC chart with Relative strength index indicator sample.
class RSIIndicator extends SampleView {
  /// Creates the OHLC chart with Relative strength index indicator.
  const RSIIndicator(Key key) : super(key: key);

  @override
  _RSIIndicatorState createState() => _RSIIndicatorState();
}

/// State class of the the OHLC chart with Relative strength index indicator.
class _RSIIndicatorState extends SampleViewState {
  _RSIIndicatorState();
  double _period = 14.0;
  double _overBought = 80.0;
  double _overSold = 20.0;
  bool _showZones = true;

  @override
  void initState() {
    _period = 14.0;
    _overBought = 80.0;
    _overSold = 20.0;
    _showZones = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getDefaultRSIIndicator();
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
                  padding: const EdgeInsets.fromLTRB(88, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(49, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
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
                'Oversold',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(68, 0, 0, 0),
                  child: HandCursor(
                    child: CustomDirectionalButtons(
                      minValue: 0,
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
                      letterSpacing: 0.34,
                      fontWeight: FontWeight.normal)),
              Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                      child: HandCursor(
                        child: CustomCheckBox(
                          activeColor: model.backgroundColor,
                          switchValue: _showZones,
                          valueChanged: (dynamic value) {
                            setState(() {
                              _showZones = value;
                            });
                          },
                        ),
                      ))),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns the OHLC chart with Relative strength index indicator.
  SfCartesianChart _getDefaultRSIIndicator() {
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
          /// RSI indicator mentioned here.
          RsiIndicator<ChartSampleData, DateTime>(
              seriesName: 'AAPL',
              yAxisName: 'yaxes',
              overbought: _overBought ?? 80,
              oversold: _overSold ?? 20,
              showZones: _showZones ?? true,
              period: _period.toInt() ?? 14),
        ],
        title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
        series: _getDataLabelHilotSeries());
  }

  /// Returns the list of chart series which need to render on the OHLC chart.
  List<ChartSeries<ChartSampleData, DateTime>> _getDataLabelHilotSeries() {
    final List<ChartSampleData> chartData = getChartData();
    return <ChartSeries<ChartSampleData, DateTime>>[
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
    ];
  }
}
