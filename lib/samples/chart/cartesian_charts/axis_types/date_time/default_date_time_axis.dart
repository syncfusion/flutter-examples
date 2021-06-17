/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the line chart with default data time axis sample.
class DateTimeDefault extends SampleView {
  /// Creates the line chart with default data time axis sample.
  const DateTimeDefault(Key key) : super(key: key);

  @override
  _DateTimeDefaultState createState() => _DateTimeDefaultState();
}

/// State class of the line chart with default data time axis.
class _DateTimeDefaultState extends SampleViewState {
  _DateTimeDefaultState();
  late TrackballBehavior _trackballBehavior;
  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
            format: 'point.x : point.y', borderWidth: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultDateTimeAxisChart();
  }

  /// Returns the line chart with default datetime axis.
  SfCartesianChart _buildDefaultDateTimeAxisChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
            text: isCardView
                ? ''
                : 'Euro to USD monthly exchange rate - 2015 to 2018'),
        primaryXAxis:
            DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
          minimum: 1,
          maximum: 1.35,
          interval: 0.05,
          labelFormat: r'${value}',
          title: AxisTitle(text: isCardView ? '' : 'Dollars'),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: _getDefaultDateTimeSeries(),
        trackballBehavior: _trackballBehavior);
  }

  /// Returns the line chart with default data time axis.
  List<LineSeries<ChartSampleData, DateTime>> _getDefaultDateTimeSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015, 1, 1), yValue: 1.13),
      ChartSampleData(x: DateTime(2015, 2, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 3, 1), yValue: 1.08),
      ChartSampleData(x: DateTime(2015, 4, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 5, 1), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 6, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 7, 1), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 8, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 9, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 10, 1), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 11, 1), yValue: 1.06),
      ChartSampleData(x: DateTime(2015, 12, 1), yValue: 1.09),
      ChartSampleData(x: DateTime(2016, 1, 1), yValue: 1.09),
      ChartSampleData(x: DateTime(2016, 2, 1), yValue: 1.09),
      ChartSampleData(x: DateTime(2016, 3, 1), yValue: 1.14),
      ChartSampleData(x: DateTime(2016, 4, 1), yValue: 1.14),
      ChartSampleData(x: DateTime(2016, 5, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2016, 6, 1), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 7, 1), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 8, 1), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 9, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2016, 10, 1), yValue: 1.1),
      ChartSampleData(x: DateTime(2016, 11, 1), yValue: 1.08),
      ChartSampleData(x: DateTime(2016, 12, 1), yValue: 1.05),
      ChartSampleData(x: DateTime(2017, 1, 1), yValue: 1.08),
      ChartSampleData(x: DateTime(2017, 2, 1), yValue: 1.06),
      ChartSampleData(x: DateTime(2017, 3, 1), yValue: 1.07),
      ChartSampleData(x: DateTime(2017, 4, 1), yValue: 1.09),
      ChartSampleData(x: DateTime(2017, 5, 1), yValue: 1.12),
      ChartSampleData(x: DateTime(2017, 6, 1), yValue: 1.14),
      ChartSampleData(x: DateTime(2017, 7, 1), yValue: 1.17),
      ChartSampleData(x: DateTime(2017, 8, 1), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 9, 1), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 10, 1), yValue: 1.16),
      ChartSampleData(x: DateTime(2017, 11, 1), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 12, 1), yValue: 1.2),
      ChartSampleData(x: DateTime(2018, 1, 1), yValue: 1.25),
      ChartSampleData(x: DateTime(2018, 2, 1), yValue: 1.22),
      ChartSampleData(x: DateTime(2018, 3, 1), yValue: 1.23),
      ChartSampleData(x: DateTime(2018, 4, 1), yValue: 1.21),
      ChartSampleData(x: DateTime(2018, 5, 1), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 6, 1), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 7, 1), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 8, 1), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 9, 1), yValue: 1.16),
      ChartSampleData(x: DateTime(2018, 10, 1), yValue: 1.13),
      ChartSampleData(x: DateTime(2018, 11, 1), yValue: 1.14),
      ChartSampleData(x: DateTime(2018, 12, 1), yValue: 1.15)
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x as DateTime,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        color: const Color.fromRGBO(242, 117, 7, 1),
      )
    ];
  }
}
