/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the multiple bubble series chart sample
class BubbleMultiSeries extends SampleView {
  /// Creates the multiple bubble series chart
  const BubbleMultiSeries(Key key) : super(key: key);

  @override
  _BubbleMultiSeriesState createState() => _BubbleMultiSeriesState();
}

/// State class of the multiple bubble series chart
class _BubbleMultiSeriesState extends SampleViewState {
  _BubbleMultiSeriesState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        textAlignment: ChartAlignment.center,
        enable: true,
        header: '',
        canShowMarker: false,
        format:
            'Literacy rate : point.x%\nGDP growth rate : point.y\nPopulation : point.sizeB');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultipleSeriesBubbleChart();
  }

  /// Returns the multiple bubble series chart
  SfCartesianChart _buildMultipleSeriesBubbleChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'World countries details'),
      primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(text: isCardView ? '' : 'Literacy rate'),
          minimum: 60,
          maximum: 100),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          title: AxisTitle(text: isCardView ? '' : 'GDP growth rate')),
      series: _getMultipleBubbleSeries(),
      legend: Legend(
          isVisible: isCardView ? false : true,
          overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart sereis
  /// which need to render on the multiple bubble series
  List<BubbleSeries<ChartSampleData, num>> _getMultipleBubbleSeries() {
    final List<ChartSampleData> asia = <ChartSampleData>[
      ChartSampleData(x: 'China', xValue: 92.2, y: 7.8, size: 1.347),
      ChartSampleData(x: 'India', xValue: 74, y: 6.5, size: 1.241),
      ChartSampleData(x: 'Indonesia', xValue: 90.4, y: 6.0, size: 0.238),
      ChartSampleData(x: 'Japan', xValue: 99, y: 0.2, size: 0.128),
      ChartSampleData(x: 'Philippines', xValue: 92.6, y: 6.6, size: 0.096),
      ChartSampleData(x: 'Hong Kong', xValue: 82.2, y: 3.97, size: 0.7),
      ChartSampleData(x: 'Jordan', xValue: 72.5, y: 4.5, size: 0.7),
      ChartSampleData(x: 'Australia', xValue: 81, y: 3.5, size: 0.21),
      ChartSampleData(x: 'Mongolia', xValue: 66.8, y: 3.9, size: 0.028),
      ChartSampleData(x: 'Taiwan', xValue: 78.4, y: 2.9, size: 0.231),
    ];
    final List<ChartSampleData> africa = <ChartSampleData>[
      ChartSampleData(x: 'Egypt', xValue: 72, y: 2.0, size: 0.0826),
      ChartSampleData(x: 'Nigeria', xValue: 61.3, y: 1.45, size: 0.162),
    ];
    final List<ChartSampleData> northAmerica = <ChartSampleData>[
      ChartSampleData(x: 'US', xValue: 99.4, y: 2.2, size: 0.312),
      ChartSampleData(x: 'Mexico', xValue: 86.1, y: 4.0, size: 0.115)
    ];
    final List<ChartSampleData> europe = <ChartSampleData>[
      ChartSampleData(x: 'Germany', xValue: 99, y: 0.7, size: 0.0818),
      ChartSampleData(x: 'Russia', xValue: 99.6, y: 3.4, size: 0.143),
      ChartSampleData(x: 'Netherland', xValue: 79.2, y: 3.9, size: 0.162)
    ];
    return <BubbleSeries<ChartSampleData, num>>[
      BubbleSeries<ChartSampleData, num>(
          opacity: 0.7,
          name: 'North America',
          dataSource: northAmerica,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          sizeValueMapper: (ChartSampleData sales, _) => sales.size),
      BubbleSeries<ChartSampleData, num>(
          opacity: 0.7,
          name: 'Europe',
          dataSource: europe,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          sizeValueMapper: (ChartSampleData sales, _) => sales.size),
      BubbleSeries<ChartSampleData, num>(
          opacity: 0.7,
          dataSource: asia,
          name: 'Asia',
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          sizeValueMapper: (ChartSampleData sales, _) => sales.size),
      BubbleSeries<ChartSampleData, num>(
          opacity: 0.7,
          name: 'Africa',
          dataSource: africa,
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          sizeValueMapper: (ChartSampleData sales, _) => sales.size),
    ];
  }
}
