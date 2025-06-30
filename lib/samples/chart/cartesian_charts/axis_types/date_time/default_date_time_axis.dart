/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart with default DataTime axis sample.
class DateTimeDefault extends SampleView {
  const DateTimeDefault(Key key) : super(key: key);

  @override
  _DateTimeDefaultState createState() => _DateTimeDefaultState();
}

/// State class of the Line Chart with default DataTime axis.
class _DateTimeDefaultState extends SampleViewState {
  _DateTimeDefaultState();

  List<ChartSampleData>? _monthlyExchangeRateDataOfEuroToUSD;
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    _monthlyExchangeRateDataOfEuroToUSD = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015), yValue: 1.13),
      ChartSampleData(x: DateTime(2015, 2), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 3), yValue: 1.08),
      ChartSampleData(x: DateTime(2015, 4), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 5), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 6), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 7), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 8), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 9), yValue: 1.12),
      ChartSampleData(x: DateTime(2015, 10), yValue: 1.1),
      ChartSampleData(x: DateTime(2015, 11), yValue: 1.06),
      ChartSampleData(x: DateTime(2015, 12), yValue: 1.09),
      ChartSampleData(x: DateTime(2016), yValue: 1.09),
      ChartSampleData(x: DateTime(2016, 2), yValue: 1.09),
      ChartSampleData(x: DateTime(2016, 3), yValue: 1.14),
      ChartSampleData(x: DateTime(2016, 4), yValue: 1.14),
      ChartSampleData(x: DateTime(2016, 5), yValue: 1.12),
      ChartSampleData(x: DateTime(2016, 6), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 7), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 8), yValue: 1.11),
      ChartSampleData(x: DateTime(2016, 9), yValue: 1.12),
      ChartSampleData(x: DateTime(2016, 10), yValue: 1.1),
      ChartSampleData(x: DateTime(2016, 11), yValue: 1.08),
      ChartSampleData(x: DateTime(2016, 12), yValue: 1.05),
      ChartSampleData(x: DateTime(2017), yValue: 1.08),
      ChartSampleData(x: DateTime(2017, 2), yValue: 1.06),
      ChartSampleData(x: DateTime(2017, 3), yValue: 1.07),
      ChartSampleData(x: DateTime(2017, 4), yValue: 1.09),
      ChartSampleData(x: DateTime(2017, 5), yValue: 1.12),
      ChartSampleData(x: DateTime(2017, 6), yValue: 1.14),
      ChartSampleData(x: DateTime(2017, 7), yValue: 1.17),
      ChartSampleData(x: DateTime(2017, 8), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 9), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 10), yValue: 1.16),
      ChartSampleData(x: DateTime(2017, 11), yValue: 1.18),
      ChartSampleData(x: DateTime(2017, 12), yValue: 1.2),
      ChartSampleData(x: DateTime(2018), yValue: 1.25),
      ChartSampleData(x: DateTime(2018, 2), yValue: 1.22),
      ChartSampleData(x: DateTime(2018, 3), yValue: 1.23),
      ChartSampleData(x: DateTime(2018, 4), yValue: 1.21),
      ChartSampleData(x: DateTime(2018, 5), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 6), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 7), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 8), yValue: 1.17),
      ChartSampleData(x: DateTime(2018, 9), yValue: 1.16),
      ChartSampleData(x: DateTime(2018, 10), yValue: 1.13),
      ChartSampleData(x: DateTime(2018, 11), yValue: 1.14),
      ChartSampleData(x: DateTime(2018, 12), yValue: 1.15),
    ];
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Euro to USD monthly exchange rate - 2015 to 2018',
      ),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 1,
        maximum: 1.35,
        interval: 0.05,
        labelFormat: r'${value}',
        title: AxisTitle(text: isCardView ? '' : 'Dollars'),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      trackballBehavior: _trackballBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _monthlyExchangeRateDataOfEuroToUSD,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.yValue,
        color: const Color.fromRGBO(242, 117, 7, 1),
      ),
    ];
  }

  @override
  void dispose() {
    _monthlyExchangeRateDataOfEuroToUSD!.clear();
    super.dispose();
  }
}
