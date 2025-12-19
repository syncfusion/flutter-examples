/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';

/// Renders the Spline Chart with trend forecasting sample.
class TrendLineForecast extends SampleView {
  const TrendLineForecast(Key key) : super(key: key);

  @override
  _TrendLineForecastState createState() => _TrendLineForecastState();
}

/// State class of the Spline Chart with trend forecasting.
class _TrendLineForecastState extends SampleViewState {
  _TrendLineForecastState();

  late double _backwardForecastValue;
  late double _forwardForecastValue;
  late int j;
  TooltipBehavior? _tooltipBehavior;
  late List<ChartSampleData> _trendLineData;
  List<double>? yValue;

  @override
  void initState() {
    _backwardForecastValue = 0.0;
    _forwardForecastValue = 0.0;
    j = 0;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _trendLineData = <ChartSampleData>[];
    yValue = <double>[
      1.2,
      1.07,
      0.92,
      0.90,
      0.94,
      1.13,
      1.24,
      1.25,
      1.26,
      1.37,
      1.47,
      1.39,
      1.33,
      1.39,
      1.29,
      1.33,
      1.33,
      1.11,
      1.11,
      1.13,
      1.18,
      1.12,
    ];
    for (int i = 1999; i <= 2019; i++) {
      _trendLineData.add(ChartSampleData(x: i, y: yValue![j]));
      j++;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = model.themeData;
    return _buildCartesianChart(
      themeData.useMaterial3,
      themeData.brightness == Brightness.light,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                'Forward forecast',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
            ),
            CustomDirectionalButtons(
              maxValue: 50,
              initialValue: _forwardForecastValue,
              onChanged: (double val) => setState(() {
                _forwardForecastValue = val;
              }),
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 20.0, color: model.textColor),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                'Backward forecast',
                style: TextStyle(fontSize: 16.0, color: model.textColor),
              ),
            ),
            CustomDirectionalButtons(
              maxValue: 50,
              initialValue: _backwardForecastValue,
              onChanged: (double val) => setState(() {
                _backwardForecastValue = val;
              }),
              loop: true,
              iconColor: model.textColor,
              style: TextStyle(fontSize: 20.0, color: model.textColor),
            ),
          ],
        ),
      ],
    );
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart(bool isMaterial3, bool isLightMode) {
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(99, 85, 199, 1)
              : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Euro to USD yearly exchange rate - 1999 to 2019',
      ),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        interval: 2,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Dollars'),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        minimum: 0.8,
        maximum: 1.8,
        interval: 0.2,
        labelFormat: r'${value}',
      ),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
      series: <SplineSeries<ChartSampleData, num>>[
        SplineSeries<ChartSampleData, num>(
          dataSource: _trendLineData,
          xValueMapper: (ChartSampleData data, int index) => data.x,
          yValueMapper: (ChartSampleData data, int index) => data.y,
          color: color,
          name: 'Exchange rate',
          markerSettings: const MarkerSettings(isVisible: true),
          trendlines: <Trendline>[
            Trendline(
              width: 3,
              dashArray: <double>[10, 10],
              name: 'Linear',

              /// Here we mention the forward and backward forecast value.
              forwardForecast: _forwardForecastValue,
              backwardForecast: _backwardForecastValue,
            ),
          ],
        ),
      ],
    );
  }
}
