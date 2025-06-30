/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../model/sample_view.dart';
import '../../../../widgets/custom_button.dart';
import 'indicator_data_source.dart';

/// Renders the OHLC series chart with Moving average convergence
/// divergence indicator sample.
class MACDIndicator extends SampleView {
  /// creates the OHLC chart with Moving average convergence
  /// divergence indicator sample.
  const MACDIndicator(Key key) : super(key: key);

  @override
  _MACDIndicatorState createState() => _MACDIndicatorState();
}

/// State class for the OHLC series chart Moving average convergence
/// divergence indicator sample.
class _MACDIndicatorState extends SampleViewState {
  _MACDIndicatorState();
  late double _period;
  late double _longPeriod;
  late double _shortPeriod;
  late String _selectedMacdIndicatorType;
  late MacdType _macdType = MacdType.both;

  List<ChartSampleData>? _chartData;
  List<String>? _macdIndicatorTypeList;

  TrackballBehavior? _trackballBehavior;

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
    _chartData = getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultMACDIndicator();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.7 * screenWidth;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[_buildSettingsRow(dropDownWidth, stateSetter)],
        );
      },
    );
  }

  /// Builds the main settings row containing period and MACD type settings.
  Widget _buildSettingsRow(double dropDownWidth, StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Expanded(flex: model.isMobile ? 2 : 1, child: Container()),
        Expanded(
          flex: 14,
          child: Column(
            children: <Widget>[
              _buildPeriodSetting(dropDownWidth),
              _buildLongPeriodSetting(dropDownWidth),
              const SizedBox(height: 6.0),
              _buildShortPeriodSetting(),
              _buildMacdTypeSetting(stateSetter),
            ],
          ),
        ),
        Expanded(flex: model.isMobile ? 3 : 1, child: Container()),
      ],
    );
  }

  /// Builds the period setting UI.
  Widget _buildPeriodSetting(double dropDownWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            'Period',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
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
              style: TextStyle(fontSize: 20.0, color: model.textColor),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the long period setting UI.
  Widget _buildLongPeriodSetting(double dropDownWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            model.isWebFullView ? 'Long \nperiod' : 'Long period',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
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
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the short period setting UI.
  Widget _buildShortPeriodSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Text(
            model.isWebFullView ? 'Short \nperiod' : 'Short period',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
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
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the MACD type setting UI.
  Widget _buildMacdTypeSetting(StateSetter stateSetter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            'MACD type',
            softWrap: false,
            style: TextStyle(fontSize: 16, color: model.textColor),
          ),
        ),
        Flexible(
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _selectedMacdIndicatorType,
            items: _macdIndicatorTypeList!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'Both',
                child: Text(value, style: TextStyle(color: model.textColor)),
              );
            }).toList(),
            onChanged: (String? value) {
              _onMacdIndicatorTypeChanged(value.toString());
              stateSetter(() {});
            },
          ),
        ),
      ],
    );
  }

  /// Returns a cartesian OHLC chart with Moving average
  /// convergence divergence indicator.
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
      primaryYAxis: const NumericAxis(
        minimum: 70,
        maximum: 130,
        interval: 20,
        axisLine: AxisLine(width: 0),
      ),
      axes: const <ChartAxis>[
        NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          opposedPosition: true,
          name: 'yAxis',
          interval: 2,
        ),
      ],
      indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
        /// MACD indicator for the 'AAPL' series.
        MacdIndicator<ChartSampleData, DateTime>(
          period: _period.toInt(),
          longPeriod: _longPeriod.toInt(),
          shortPeriod: _shortPeriod.toInt(),
          macdType: _macdType,
          seriesName: 'AAPL',
          yAxisName: 'yAxis',
        ),
      ],
      trackballBehavior: _trackballBehavior,
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

  /// Method for updating the Macd indicator type in the chart on change.
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
      /// Update the MACD type changes.
    });
  }

  @override
  void dispose() {
    _macdIndicatorTypeList!.clear();
    _chartData!.clear();
    super.dispose();
  }
}
