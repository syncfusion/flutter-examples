/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

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
            model.isWeb
        ? (MediaQuery.of(context).size.width / 100 * 14)
        : (MediaQuery.of(context).size.width / 100) * 5;
    return _getDefaultAnimationChart();
  }

  ChartSeriesController _chartSeriesController1, _chartSeriesController2;
  // @override
  // Widget buildSettings(BuildContext context) {
  //   return ListView(
  //     children: <Widget>[
  //       Padding(
  //           padding: EdgeInsets.only(right: model.isWeb ? 0 : 15),
  //           child: Column(
  //             children: [
  //               Container(
  //                   width: 180,
  //                   child: RaisedButton(
  //                     color: model.backgroundColor,
  //                     onPressed: () {
  //                       _chartSeriesController2?.animate();
  //                     },
  //                     child: Text('Animate line series',
  //                         style: TextStyle(color: Colors.white)),
  //                   )),
  //               Container(
  //                   width: 180,
  //                   child: RaisedButton(
  //                     color: model.backgroundColor,
  //                     onPressed: () {
  //                       _chartSeriesController1?.animate();
  //                     },
  //                     child: Text('Animate column series',
  //                         style: TextStyle(color: Colors.white)),
  //                   )),
  //               Container(
  //                   width: 180,
  //                   child: RaisedButton(
  //                     color: model.backgroundColor,
  //                     onPressed: () {
  //                       _chartSeriesController1?.animate();
  //                       _chartSeriesController2?.animate();
  //                     },
  //                     child: Text('Animate both',
  //                         style: TextStyle(color: Colors.white)),
  //                   )),
  //             ],
  //           ))
  //     ],
  //   );
  // }

  /// Returns the cartesian chart with default serie animation.
  Column _getDefaultAnimationChart() {
    return Column(children: [
      Expanded(
          child: SfCartesianChart(
        title: ChartTitle(text: isCardView ? '' : 'Sales report'),
        legend: Legend(isVisible: !isCardView),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            minimum: 0,
            interval: isCardView ? 50 : 25,
            maximum: 150,
            majorGridLines: MajorGridLines(width: 0)),
        axes: <ChartAxis>[
          NumericAxis(
              numberFormat: NumberFormat.compact(),
              majorGridLines: MajorGridLines(width: 0),
              opposedPosition: true,
              name: 'yAxis1',
              interval: 1000,
              minimum: 0,
              maximum: 7000)
        ],
        series: _getDefaultAnimationSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      )),
      isCardView
          ? Container(height: 0, width: 0)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: model.isWeb
                        ? ButtonTheme(
                            minWidth: 40.0,
                            height: 30.0,
                            child: _getColumnButton())
                        : _getColumnButton()),
                Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                Container(
                    child: model.isWeb
                        ? ButtonTheme(
                            minWidth: 40.0,
                            height: 30.0,
                            child: _getLineButton())
                        : _getLineButton()),
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
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Unit Sold'),
      LineSeries<ChartSampleData, String>(
          animationDuration: 4500,
          dataSource: chartData,
          width: 2,
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController2 = controller;
          },
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          yAxisName: 'yAxis1',
          markerSettings: MarkerSettings(isVisible: true),
          name: 'Total Transaction')
    ];
  }

  RaisedButton _getColumnButton() {
    return RaisedButton(
      color: model.backgroundColor,
      onPressed: () {
        _chartSeriesController2?.animate();
      },
      child: Text('Animate line series',
          textScaleFactor: 1, style: TextStyle(color: Colors.white)),
    );
  }

  RaisedButton _getLineButton() {
    return RaisedButton(
      color: model.backgroundColor,
      onPressed: () {
        _chartSeriesController1?.animate();
      },
      child: Text('Animate column series',
          textScaleFactor: 1, style: TextStyle(color: Colors.white)),
    );
  }
}
