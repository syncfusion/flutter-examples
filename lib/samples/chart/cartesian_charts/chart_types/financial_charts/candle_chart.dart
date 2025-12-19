/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the default Candle series chart.
class CandleChart extends SampleView {
  /// Creates the default Candle series chart.
  const CandleChart(Key key) : super(key: key);

  @override
  _CandleChartState createState() => _CandleChartState();
}

class _CandleChartState extends SampleViewState {
  _CandleChartState();
  late bool _enableSolidCandle;
  late bool _toggleVisibility;
  late double _width;
  late double _space;
  late double _borderRadius;

  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _width = 0.8;
    _space = 0.2;
    _borderRadius = 5;
    _enableSolidCandle = false;
    _toggleVisibility = true;
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(
        x: DateTime(2016, 01, 11),
        open: 98.97,
        high: 101.19,
        low: 95.36,
        close: 97.13,
      ),
      ChartSampleData(
        x: DateTime(2016, 01, 18),
        open: 98.41,
        high: 101.46,
        low: 93.42,
        close: 101.42,
      ),
      ChartSampleData(
        x: DateTime(2016, 01, 25),
        open: 101.52,
        high: 101.53,
        low: 92.39,
        close: 97.34,
      ),
      ChartSampleData(
        x: DateTime(2016, 02),
        open: 96.47,
        high: 97.33,
        low: 93.69,
        close: 94.02,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 08),
        open: 93.13,
        high: 96.35,
        low: 92.59,
        close: 93.99,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 15),
        open: 95.02,
        high: 98.89,
        low: 94.61,
        close: 96.04,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 22),
        open: 96.31,
        high: 98.0237,
        low: 93.32,
        close: 96.91,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 29),
        open: 96.86,
        high: 103.75,
        low: 96.65,
        close: 103.01,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 07),
        open: 102.39,
        high: 102.83,
        low: 100.15,
        close: 102.26,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 14),
        open: 106.5,
        high: 106.5,
        low: 106.5,
        close: 106.5,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 21),
        open: 105.93,
        high: 107.65,
        low: 104.89,
        close: 105.67,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 28),
        open: 106,
        high: 110.42,
        low: 104.88,
        close: 109.99,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 04),
        open: 110.42,
        high: 112.19,
        low: 108.121,
        close: 108.66,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 11),
        open: 108.97,
        high: 112.39,
        low: 108.66,
        close: 109.85,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 18),
        open: 108.89,
        high: 108.95,
        low: 104.62,
        close: 105.68,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 25),
        open: 105,
        high: 105.65,
        low: 92.51,
        close: 93.74,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 02),
        open: 93.965,
        high: 95.9,
        low: 91.85,
        close: 92.72,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 09),
        open: 93,
        high: 93.77,
        low: 89.47,
        close: 90.52,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 16),
        open: 92.39,
        high: 95.43,
        low: 91.65,
        close: 95.22,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 23),
        open: 95.87,
        high: 100.73,
        low: 95.67,
        close: 100.35,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 30),
        open: 99.6,
        high: 100.4,
        low: 96.63,
        close: 97.92,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 06),
        open: 97.99,
        high: 101.89,
        low: 97.55,
        close: 98.83,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 13),
        open: 98.69,
        high: 99.12,
        low: 95.3,
        close: 95.33,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 20),
        open: 96,
        high: 96.89,
        low: 92.65,
        close: 93.4,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 27),
        open: 93,
        high: 96.465,
        low: 91.5,
        close: 95.89,
      ),
      ChartSampleData(
        x: DateTime(2016, 07, 04),
        open: 95.39,
        high: 96.89,
        low: 94.37,
        close: 96.68,
      ),
      ChartSampleData(
        x: DateTime(2016, 07, 11),
        open: 96.75,
        high: 99.3,
        low: 96.73,
        close: 98.78,
      ),
      ChartSampleData(
        x: DateTime(2016, 07, 18),
        open: 98.7,
        high: 101,
        low: 98.31,
        close: 98.66,
      ),
      ChartSampleData(
        x: DateTime(2016, 07, 25),
        open: 98.25,
        high: 104.55,
        low: 96.42,
        close: 104.21,
      ),
      ChartSampleData(
        x: DateTime(2016, 08),
        open: 104.41,
        high: 107.65,
        low: 104,
        close: 107.48,
      ),
      ChartSampleData(
        x: DateTime(2016, 08, 08),
        open: 107.52,
        high: 108.94,
        low: 107.16,
        close: 108.18,
      ),
      ChartSampleData(
        x: DateTime(2016, 08, 15),
        open: 108.14,
        high: 110.23,
        low: 108.08,
        close: 109.36,
      ),
      ChartSampleData(
        x: DateTime(2016, 08, 22),
        open: 108.86,
        high: 109.32,
        low: 106.31,
        close: 106.94,
      ),
      ChartSampleData(
        x: DateTime(2016, 08, 29),
        open: 109.74,
        high: 109.74,
        low: 109.74,
        close: 109.74,
      ),
      ChartSampleData(
        x: DateTime(2016, 09, 05),
        open: 107.9,
        high: 108.76,
        low: 103.13,
        close: 103.13,
      ),
      ChartSampleData(
        x: DateTime(2016, 09, 12),
        open: 102.65,
        high: 116.13,
        low: 102.53,
        close: 114.92,
      ),
      ChartSampleData(
        x: DateTime(2016, 09, 19),
        open: 115.19,
        high: 116.18,
        low: 111.55,
        close: 112.71,
      ),
      ChartSampleData(
        x: DateTime(2016, 09, 26),
        open: 111.64,
        high: 114.64,
        low: 111.55,
        close: 113.05,
      ),
    ];
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildEnableSolidCandlesRow(stateSetter),
            _buildShowIndicationRow(stateSetter),
            _buildWidthRow(),
            _buildSpacingRow(),
            _buildBorderRadiusRow(),
          ],
        );
      },
    );
  }

  // Method to build the row for enabling solid candles.
  Widget _buildEnableSolidCandlesRow(StateSetter stateSetter) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Enable solid candles',
            style: TextStyle(color: model.textColor, fontSize: 16),
          ),
          SizedBox(
            width: 90,
            child: CheckboxListTile(
              activeColor: model.primaryColor,
              value: _enableSolidCandle,
              onChanged: (bool? value) {
                setState(() {
                  _enableSolidCandle = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the row for showing indication for same values.
  Widget _buildShowIndicationRow(StateSetter stateSetter) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Show indication for  \nsame values',
            style: TextStyle(color: model.textColor, fontSize: 16),
          ),
          SizedBox(
            width: 87,
            child: CheckboxListTile(
              activeColor: model.primaryColor,
              value: _toggleVisibility,
              onChanged: (bool? value) {
                setState(() {
                  _toggleVisibility = value!;
                  stateSetter(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the row for setting width.
  Widget _buildWidthRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text('Width  ', style: TextStyle(color: model.textColor)),
        ),
        CustomDirectionalButtons(
          maxValue: 1,
          initialValue: _width,
          onChanged: (double val) {
            setState(() {
              _width = val;
            });
          },
          step: 0.1,
          loop: true,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
      ],
    );
  }

  // Method to build the row for setting spacing.
  Widget _buildSpacingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text('Spacing  ', style: TextStyle(color: model.textColor)),
        ),
        CustomDirectionalButtons(
          maxValue: 1,
          initialValue: _space,
          onChanged: (double val) {
            setState(() {
              _space = val;
            });
          },
          step: 0.1,
          loop: true,
          padding: 5.0,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
      ],
    );
  }

  // Method to build the row for setting border radius.
  Widget _buildBorderRadiusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            'Border Radius  ',
            style: TextStyle(color: model.textColor),
          ),
        ),
        CustomDirectionalButtons(
          maxValue: 10,
          initialValue: _borderRadius,
          onChanged: (double val) {
            setState(() {
              _borderRadius = val;
            });
          },
          loop: true,
          padding: 5.0,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCandle();
  }

  /// Returns the cartesian candle chart.
  SfCartesianChart _buildCandle() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
        autoScrollingDelta: 3,
        autoScrollingMode: AutoScrollingMode.start,
        dateFormat: DateFormat.MMM(),
        interval: 1,
        intervalType: DateTimeIntervalType.months,
        minimum: DateTime(2016),
        maximum: DateTime(2016, 10),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 80,
        maximum: 120,
        interval: 20,
        labelFormat: r'${value}',
        axisLine: AxisLine(width: 0),
      ),
      series: _buildCandleSeries(),
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enablePinching: true,
        enablePanning: true,
      ),
    );
  }

  /// Returns the list of cartesian candle series chart.
  List<CandleSeries<ChartSampleData, DateTime>> _buildCandleSeries() {
    return <CandleSeries<ChartSampleData, DateTime>>[
      CandleSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,

        /// High, low, open and close values used to render the candle series.
        lowValueMapper: (ChartSampleData data, int index) => data.low,
        highValueMapper: (ChartSampleData data, int index) => data.high,
        openValueMapper: (ChartSampleData data, int index) => data.open,
        closeValueMapper: (ChartSampleData data, int index) => data.close,
        enableSolidCandles: _enableSolidCandle,
        spacing: _space,
        width: _width,
        showIndicationForSameValues: isCardView ? true : _toggleVisibility,
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        name: 'AAPL',
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}
