/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the cartesian chart with default serie animation sample.
class AnimationDefault extends SampleView {
  /// Creates the cartesian chart with default serie animation sample.
  const AnimationDefault(Key key) : super(key: key);

  @override
  _AnimationDefaultState createState() => _AnimationDefaultState();
}

/// State class of the cartesian chart with default serie animation.
class _AnimationDefaultState extends SampleViewState {
  _AnimationDefaultState();
  double padding = 0;
  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.of(context).orientation == Orientation.landscape ||
            model.isWebFullView
        ? (MediaQuery.of(context).size.width / 100 * 14)
        : (MediaQuery.of(context).size.width / 100) * 5;
    return _buildDefaultAnimationChart();
  }

  ChartSeriesController? _chartSeriesController1, _chartSeriesController2;

  /// Returns the cartesian chart with default serie animation.
  Column _buildDefaultAnimationChart() {
    return Column(children: <Widget>[
      Expanded(
          child: SfCartesianChart(
        title: ChartTitle(text: isCardView ? '' : 'Sales report'),
        legend: Legend(isVisible: !isCardView),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            minimum: 0,
            interval: isCardView ? 50 : 25,
            maximum: 150,
            majorGridLines: const MajorGridLines(width: 0)),
        axes: <ChartAxis>[
          NumericAxis(
              numberFormat: NumberFormat.compact(),
              majorGridLines: const MajorGridLines(width: 0),
              opposedPosition: true,
              name: 'yAxis1',
              interval: 1000,
              minimum: 0,
              maximum: 7000)
        ],
        series: _getDefaultAnimationSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      )),
      if (isCardView)
        Container(height: 0, width: 0)
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: model.isWebFullView
                    ? ButtonTheme(
                        minWidth: 40.0,
                        height: 30.0,
                        child: _buildColumnButton())
                    : _buildColumnButton()),
            const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
            Container(
                child: model.isWebFullView
                    ? ButtonTheme(
                        minWidth: 40.0, height: 30.0, child: _buildLineButton())
                    : _buildLineButton()),
          ],
        )
    ]);
  }

  /// Returns the list of chart which need to render on the cartesian chart.
  List<ChartSeries<ChartSampleData, String>> _getDefaultAnimationSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 45, secondSeriesYValue: 1000),
      ChartSampleData(x: 'Feb', y: 100, secondSeriesYValue: 3000),
      ChartSampleData(x: 'March', y: 25, secondSeriesYValue: 1000),
      ChartSampleData(x: 'April', y: 100, secondSeriesYValue: 7000),
      ChartSampleData(x: 'May', y: 85, secondSeriesYValue: 5000),
      ChartSampleData(x: 'June', y: 140, secondSeriesYValue: 7000)
    ];
    return <ChartSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          animationDuration: 2000,
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController1 = controller;
          },
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Unit Sold'),
      LineSeries<ChartSampleData, String>(
          animationDuration: 4500,
          dataSource: chartData,
          width: 2,
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController2 = controller;
          },
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          yAxisName: 'yAxis1',
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Total Transaction')
    ];
  }

  ElevatedButton _buildColumnButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(model.backgroundColor),
      ),
      onPressed: () {
        _chartSeriesController2?.animate();
      },
      child: const Text('Animate line series',
          textScaleFactor: 1, style: TextStyle(color: Colors.white)),
    );
  }

  ElevatedButton _buildLineButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(model.backgroundColor),
      ),
      onPressed: () {
        _chartSeriesController1?.animate();
      },
      child: const Text('Animate column series',
          textScaleFactor: 1, style: TextStyle(color: Colors.white)),
    );
  }
}
