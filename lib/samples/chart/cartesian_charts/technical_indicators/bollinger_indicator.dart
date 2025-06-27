/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC series chart with Bollinger
/// band indicator sample.
class BollingerIndicator extends SampleView {
  /// creates the OHLC series chart with Bollinger
  /// band indicator.
  const BollingerIndicator(Key key) : super(key: key);

  @override
  _BollingerIndicatorState createState() => _BollingerIndicatorState();
}

/// State class for the OHLC series chart with Bollinger
/// band indicator.
class _BollingerIndicatorState extends SampleViewState {
  _BollingerIndicatorState();
  late double _period;
  late double _standardDeviation;
  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

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
    _standardDeviation = 1;
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultBollingerIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[_buildSettingsContainer()],
    );
  }

  /// Builds the container for the settings, including labels
  /// and directional buttons.
  Widget _buildSettingsContainer() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_buildLabels(), _buildDirectionalButtons()],
      ),
    );
  }

  /// Builds the labels for the settings, including 'Period'
  /// and 'Standard Deviation'.
  Widget _buildLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Period',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        SizedBox(height: model.isMobile ? 30.0 : 16.0),
        Text(
          model.isWebFullView ? 'Standard \ndeviation' : 'Standard deviation',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
      ],
    );
  }

  /// Builds the custom directional buttons for adjusting the
  /// period and standard deviation values.
  Widget _buildDirectionalButtons() {
    return Column(
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
          style: TextStyle(fontSize: 20.0, color: model.textColor),
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
          style: TextStyle(fontSize: 20.0, color: model.textColor),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  // Returns a cartesian OHLC chart with Bollinger band indicator
  SfCartesianChart _buildDefaultBollingerIndicator() {
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
      trackballBehavior: _trackballBehavior,
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// Bollinger band indicator for the 'AAPL' series.
        BollingerBandIndicator<ChartSampleData, DateTime>(
          seriesName: 'AAPL',
          animationDuration: 0,
          period: _period.toInt(),
          standardDeviation: _standardDeviation.toInt(),
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
