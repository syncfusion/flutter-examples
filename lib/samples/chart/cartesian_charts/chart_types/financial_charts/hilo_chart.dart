/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the default High-Low series chart.
class HiloChart extends SampleView {
  /// Creates the default High-low series chart.
  const HiloChart(Key key) : super(key: key);

  @override
  _HiloChartState createState() => _HiloChartState();
}

class _HiloChartState extends SampleViewState {
  _HiloChartState();
  late bool _toggleVisibility;

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _toggleVisibility = true;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(
        x: DateTime(2016, 01, 11),
        secondSeriesYValue: 98.97,
        high: 101.19,
        low: 95.36,
        thirdSeriesYValue: 97.13,
      ),
      ChartSampleData(
        x: DateTime(2016, 01, 18),
        secondSeriesYValue: 98.41,
        high: 101.46,
        low: 93.42,
        thirdSeriesYValue: 101.42,
      ),
      ChartSampleData(
        x: DateTime(2016, 01, 25),
        secondSeriesYValue: 101.52,
        high: 101.53,
        low: 92.39,
        thirdSeriesYValue: 97.34,
      ),
      ChartSampleData(
        x: DateTime(2016, 02),
        secondSeriesYValue: 96.47,
        high: 97.33,
        low: 93.69,
        thirdSeriesYValue: 94.02,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 08),
        secondSeriesYValue: 93.13,
        high: 96.35,
        low: 92.59,
        thirdSeriesYValue: 93.99,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 15),
        secondSeriesYValue: 95.02,
        high: 98.89,
        low: 94.61,
        thirdSeriesYValue: 96.04,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 22),
        secondSeriesYValue: 92.31,
        high: 94.0237,
        low: 94.0237,
        thirdSeriesYValue: 92.91,
      ),
      ChartSampleData(
        x: DateTime(2016, 02, 29),
        secondSeriesYValue: 96.86,
        high: 103.75,
        low: 96.65,
        thirdSeriesYValue: 103.01,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 07),
        secondSeriesYValue: 102.39,
        high: 102.83,
        low: 100.15,
        thirdSeriesYValue: 102.26,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 14),
        secondSeriesYValue: 101.91,
        high: 106.5,
        low: 101.78,
        thirdSeriesYValue: 105.92,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 21),
        secondSeriesYValue: 105.93,
        high: 107.65,
        low: 104.89,
        thirdSeriesYValue: 105.67,
      ),
      ChartSampleData(
        x: DateTime(2016, 03, 28),
        secondSeriesYValue: 106,
        high: 110.42,
        low: 104.88,
        thirdSeriesYValue: 109.99,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 04),
        secondSeriesYValue: 110.42,
        high: 112.19,
        low: 108.121,
        thirdSeriesYValue: 108.66,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 11),
        secondSeriesYValue: 108.97,
        high: 112.39,
        low: 108.66,
        thirdSeriesYValue: 109.85,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 18),
        secondSeriesYValue: 108.89,
        high: 108.95,
        low: 104.62,
        thirdSeriesYValue: 105.68,
      ),
      ChartSampleData(
        x: DateTime(2016, 04, 25),
        secondSeriesYValue: 105,
        high: 105.65,
        low: 92.51,
        thirdSeriesYValue: 93.74,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 02),
        secondSeriesYValue: 93.965,
        high: 95.9,
        low: 91.85,
        thirdSeriesYValue: 92.72,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 09),
        secondSeriesYValue: 93,
        high: 93.77,
        low: 89.47,
        thirdSeriesYValue: 90.52,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 16),
        secondSeriesYValue: 92.39,
        high: 95.43,
        low: 91.65,
        thirdSeriesYValue: 95.22,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 23),
        secondSeriesYValue: 95.87,
        high: 100.73,
        low: 95.67,
        thirdSeriesYValue: 100.35,
      ),
      ChartSampleData(
        x: DateTime(2016, 05, 30),
        secondSeriesYValue: 99.6,
        high: 100.4,
        low: 96.63,
        thirdSeriesYValue: 97.92,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 06),
        secondSeriesYValue: 97.99,
        high: 101.89,
        low: 101.89,
        thirdSeriesYValue: 98.83,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 13),
        secondSeriesYValue: 98.69,
        high: 99.12,
        low: 95.3,
        thirdSeriesYValue: 95.33,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 20),
        secondSeriesYValue: 96,
        high: 96.89,
        low: 92.65,
        thirdSeriesYValue: 93.4,
      ),
      ChartSampleData(
        x: DateTime(2016, 06, 27),
        secondSeriesYValue: 93,
        high: 96.465,
        low: 91.5,
        thirdSeriesYValue: 95.89,
      ),
    ];
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          children: <Widget>[
            Text(
              'Show indication for\nsame values ',
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 90,
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHiloChart();
  }

  /// Returns the cartesian High-Low chart.
  SfCartesianChart _buildHiloChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'AAPL - 2016'),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        minimum: DateTime(2016),
        maximum: DateTime(2016, 07),
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        interval: 20,
        minimum: 60,
        maximum: 140,
        labelFormat: r'${value}',
        axisLine: AxisLine(width: 0),
      ),
      series: _buildHiloSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of High-Low series.
  List<HiloSeries<ChartSampleData, DateTime>> _buildHiloSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <HiloSeries<ChartSampleData, DateTime>>[
      HiloSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,

        /// High and low value mapper used to render the High-Low series.
        lowValueMapper: (ChartSampleData data, int index) => data.low,
        highValueMapper: (ChartSampleData data, int index) => data.high,
        color: color,
        showIndicationForSameValues: isCardView ? true : _toggleVisibility,
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
