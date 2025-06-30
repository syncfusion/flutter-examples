/// Package import.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports.
import '../../../../../model/sample_view.dart';

/// Renders the cartesian chart with default series
/// animation sample.
class AnimationDefault extends SampleView {
  /// Creates the cartesian chart with default series
  /// animation sample.
  const AnimationDefault(Key key) : super(key: key);

  @override
  _AnimationDefaultState createState() => _AnimationDefaultState();
}

/// State class for the cartesian chart with default
/// series animation.
class _AnimationDefaultState extends SampleViewState {
  _AnimationDefaultState();
  late double padding;

  ChartSeriesController<ChartSampleData, String>? _chartSeriesController1;
  ChartSeriesController<ChartSampleData, String>? _chartSeriesController2;
  List<ChartSampleData>? _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    padding = 0;
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Jan', y: 45, secondSeriesYValue: 1000),
      ChartSampleData(x: 'Feb', y: 100, secondSeriesYValue: 3000),
      ChartSampleData(x: 'March', y: 25, secondSeriesYValue: 1000),
      ChartSampleData(x: 'April', y: 100, secondSeriesYValue: 7000),
      ChartSampleData(x: 'May', y: 85, secondSeriesYValue: 5000),
      ChartSampleData(x: 'June', y: 140, secondSeriesYValue: 7000),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    padding =
        MediaQuery.of(context).orientation == Orientation.landscape ||
            model.isWebFullView
        ? (MediaQuery.of(context).size.width / 100 * 14)
        : (MediaQuery.of(context).size.width / 100) * 5;
    return _buildDefaultAnimationChart();
  }

  /// Returns a cartesian chart with default series animation.
  Column _buildDefaultAnimationChart() {
    return Column(
      children: <Widget>[
        Expanded(child: _buildCartesianChart()),
        if (isCardView)
          const SizedBox(height: 0, width: 0)
        else
          _buildChartButtonRow(),
      ],
    );
  }

  /// Returns a cartesian chart with default series animation.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales report'),
      legend: Legend(isVisible: !isCardView),
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        interval: isCardView ? 50 : 25,
        maximum: 150,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      axes: <ChartAxis>[
        NumericAxis(
          numberFormat: NumberFormat.compact(),
          majorGridLines: const MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yAxis1',
          interval: 1000,
          minimum: 0,
          maximum: 7000,
        ),
      ],
      series: _buildDefaultAnimationSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Builds a row of buttons for switching between chart types.
  Row _buildChartButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: model.isWebFullView
              ? ButtonTheme(
                  minWidth: 40.0,
                  height: 30.0,
                  child: _buildLineButton(),
                )
              : _buildLineButton(),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
        Container(
          child: model.isWebFullView
              ? ButtonTheme(
                  minWidth: 40.0,
                  height: 30.0,
                  child: _buildColumnButton(),
                )
              : _buildColumnButton(),
        ),
      ],
    );
  }

  /// Returns the list of cartesian series which need
  /// to render on the cartesian chart.
  List<CartesianSeries<ChartSampleData, String>>
  _buildDefaultAnimationSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        onRendererCreated:
            (ChartSeriesController<ChartSampleData, String> controller) {
              _chartSeriesController1 = controller;
            },
        name: 'Unit Sold',
      ),
      LineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        yAxisName: 'yAxis1',
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Total Transaction',
        onRendererCreated:
            (ChartSeriesController<ChartSampleData, String> controller) {
              _chartSeriesController2 = controller;
            },
      ),
    ];
  }

  ElevatedButton _buildColumnButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(model.primaryColor),
      ),
      onPressed: () {
        _chartSeriesController1?.animate();
      },
      child: const Text(
        'Animate column series',
        textScaler: TextScaler.noScaling,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  ElevatedButton _buildLineButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(model.primaryColor),
      ),
      onPressed: () {
        _chartSeriesController2?.animate();
      },
      child: const Text(
        'Animate line series',
        textScaler: TextScaler.noScaling,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _chartData!.clear();
    _chartSeriesController1 = null;
    _chartSeriesController2 = null;
    super.dispose();
  }
}
