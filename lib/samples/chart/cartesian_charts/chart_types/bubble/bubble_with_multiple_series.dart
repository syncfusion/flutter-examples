/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the multiple Bubble series Chart sample.
class BubbleMultiSeries extends SampleView {
  const BubbleMultiSeries(Key key) : super(key: key);

  @override
  _BubbleMultiSeriesState createState() => _BubbleMultiSeriesState();
}

/// State class of the multiple Bubble series Chart.
class _BubbleMultiSeriesState extends SampleViewState {
  _BubbleMultiSeriesState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData1;
  List<ChartSampleData>? _chartData2;
  List<ChartSampleData>? _chartData3;
  List<ChartSampleData>? _chartData4;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format:
          'Literacy rate : point.x%\nGDP growth rate : point.y\nPopulation : point.sizeB',
    );
    _chartData1 = <ChartSampleData>[
      ChartSampleData(x: 'US', xValue: 99.4, y: 2.2, size: 0.312),
      ChartSampleData(x: 'Mexico', xValue: 86.1, y: 4.0, size: 0.115),
    ];

    _chartData2 = <ChartSampleData>[
      ChartSampleData(x: 'Germany', xValue: 99, y: 0.7, size: 0.0818),
      ChartSampleData(x: 'Russia', xValue: 99.6, y: 3.4, size: 0.143),
      ChartSampleData(x: 'Netherland', xValue: 79.2, y: 3.9, size: 0.162),
    ];

    _chartData3 = <ChartSampleData>[
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

    _chartData4 = <ChartSampleData>[
      ChartSampleData(x: 'Egypt', xValue: 72, y: 2.0, size: 0.0826),
      ChartSampleData(x: 'Nigeria', xValue: 61.3, y: 1.45, size: 0.162),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Bubble series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'World countries details'),
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'Literacy rate'),
        minimum: 60,
        maximum: 100,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'GDP growth rate'),
      ),
      series: _buildBubbleSeries(),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Bubble series.
  List<BubbleSeries<ChartSampleData, num>> _buildBubbleSeries() {
    return <BubbleSeries<ChartSampleData, num>>[
      BubbleSeries<ChartSampleData, num>(
        dataSource: _chartData1,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        sizeValueMapper: (ChartSampleData sales, int index) => sales.size,
        opacity: 0.7,
        name: 'North America',
      ),
      BubbleSeries<ChartSampleData, num>(
        dataSource: _chartData2,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        sizeValueMapper: (ChartSampleData sales, int index) => sales.size,
        opacity: 0.7,
        name: 'Europe',
      ),
      BubbleSeries<ChartSampleData, num>(
        dataSource: _chartData3,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        sizeValueMapper: (ChartSampleData sales, int index) => sales.size,
        opacity: 0.7,
        name: 'Asia',
      ),
      BubbleSeries<ChartSampleData, num>(
        opacity: 0.7,
        name: 'Africa',
        dataSource: _chartData4,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        sizeValueMapper: (ChartSampleData sales, int index) => sales.size,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData1!.clear();
    _chartData2!.clear();
    _chartData3!.clear();
    _chartData4!.clear();
    super.dispose();
  }
}
