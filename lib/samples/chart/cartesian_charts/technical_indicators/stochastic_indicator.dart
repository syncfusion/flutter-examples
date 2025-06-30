/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC series chart with Stochastic indicator sample.
class StochasticcIndicator extends SampleView {
  /// creates the OHLC series chart with Stochastic indicator.
  const StochasticcIndicator(Key key) : super(key: key);

  @override
  _StochasticcIndicatorState createState() => _StochasticcIndicatorState();
}

/// State class for the OHLC chart with Stochastic indicator.
class _StochasticcIndicatorState extends SampleViewState {
  _StochasticcIndicatorState();
  late double _period;
  late double _kPeriod;
  late double _dPeriod;
  late double _overBought;
  late double _overSold;
  late bool _showZones;

  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

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
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultStochasticIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildPeriodSetting(screenWidth),
            _buildKPeriodSetting(screenWidth),
            _buildDPeriodSetting(screenWidth),
            _buildOverboughtSetting(screenWidth),
            _buildOversoldSetting(screenWidth),
            _buildShowZonesSetting(screenWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the UI for setting the 'Period'
  /// value with directional buttons.
  Widget _buildPeriodSetting(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  Period',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
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
      ],
    );
  }

  /// Builds the UI for setting the 'K Period'
  /// value with directional buttons.
  Widget _buildKPeriodSetting(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  K Period',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
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
      ],
    );
  }

  /// Builds the UI for setting the 'D Period'
  /// value with directional buttons.
  Widget _buildDPeriodSetting(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  D Period',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
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
      ],
    );
  }

  /// Builds the UI for setting the 'Overbought'
  /// value with directional buttons.
  Widget _buildOverboughtSetting(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  Overbought',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
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
      ],
    );
  }

  /// Builds the UI for setting the 'Oversold'
  /// value with directional buttons.
  Widget _buildOversoldSetting(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  Oversold',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
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
      ],
    );
  }

  /// Builds the UI for showing zones with a checkbox option.
  Widget _buildShowZonesSetting(double screenWidth, StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.isWebFullView ? '  Show \n  zones' : '  Show zones',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          padding: EdgeInsets.only(left: 0.05 * screenWidth),
          width: 0.5 * screenWidth,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: model.primaryColor,
            value: _showZones,
            onChanged: (bool? value) {
              setState(() {
                _showZones = value!;
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian OHLC chart with Stochastic indicator.
  SfCartesianChart _buildDefaultStochasticIndicator() {
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
      primaryYAxis: const NumericAxis(
        minimum: 70,
        maximum: 130,
        interval: 20,
        labelFormat: r'${value}',
        axisLine: AxisLine(width: 0),
      ),
      axes: const <ChartAxis>[
        NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yAxis',
          minimum: 10,
          maximum: 110,
          interval: 20,
          axisLine: AxisLine(width: 0),
        ),
      ],
      trackballBehavior: _trackballBehavior,
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// Stochastic indicator for the 'AAPL' series.
        StochasticIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          yAxisName: 'yAxis',
          overbought: _overBought,
          oversold: _overSold,
          showZones: _showZones,
          period: _period.toInt(),
          kPeriod: _kPeriod.toInt(),
          dPeriod: _dPeriod.toInt(),
        ),
      ],
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      series: _buildHiloOpenCloseSeries(),
    );
  }

  /// Returns the cartesian hilo open close series.
  List<CartesianSeries<ChartSampleData, DateTime>> _buildHiloOpenCloseSeries() {
    return <CartesianSeries<ChartSampleData, DateTime>>[
      HiloOpenCloseSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        lowValueMapper: (ChartSampleData data, int index) => data.low,
        highValueMapper: (ChartSampleData data, int index) => data.high,
        openValueMapper: (ChartSampleData data, int index) => data.open,
        closeValueMapper: (ChartSampleData data, int index) => data.close,
        name: 'AAPL',
        opacity: 0.7,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
