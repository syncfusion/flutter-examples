/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the radial bar series chart with legend.
class RadialBarAngle extends SampleView {
  /// Creates the radial bar series chart with legend.
  const RadialBarAngle(Key key) : super(key: key);

  @override
  _RadialBarAngleState createState() => _RadialBarAngleState();
}

/// State class for the radial bar series chart with legend.
class _RadialBarAngleState extends SampleViewState {
  _RadialBarAngleState();
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x');
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Move 65%\n338/520 CAL',
        y: 65,
        text: 'Move  ',
        pointColor: const Color.fromRGBO(0, 201, 230, 1.0),
      ),
      ChartSampleData(
        x: 'Exercise 43%\n13/30 MIN',
        y: 43,
        text: 'Exercise  ',
        pointColor: const Color.fromRGBO(63, 224, 0, 1.0),
      ),
      ChartSampleData(
        x: 'Stand 58%\n7/12 HR',
        y: 58,
        text: 'Stand  ',
        pointColor: const Color.fromRGBO(226, 1, 26, 1.0),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAngleRadialBarChart();
  }

  /// Returns a circular radial chart with legend.
  SfCircularChart _buildAngleRadialBarChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Activity tracker'),

      /// To enable the legend for radial bar series.
      legend: const Legend(
        isVisible: true,
        iconHeight: 20,
        iconWidth: 20,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: _buildRadialBarSeries(),
    );
  }

  /// Returns the circular radial bar series.
  List<RadialBarSeries<ChartSampleData, String>> _buildRadialBarSeries() {
    final List<RadialBarSeries<ChartSampleData, String>> list =
        <RadialBarSeries<ChartSampleData, String>>[
          RadialBarSeries<ChartSampleData, String>(
            dataSource: _chartData,
            xValueMapper: (ChartSampleData data, int index) => data.x,
            yValueMapper: (ChartSampleData data, int index) => data.y,
            pointColorMapper: (ChartSampleData data, int index) =>
                data.pointColor,
            dataLabelMapper: (ChartSampleData data, int index) => data.text,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            animationDuration: 0,
            maximumValue: 100,
            radius: '100%',
            gap: '2%',
            innerRadius: '30%',
            cornerStyle: CornerStyle.bothCurve,
          ),
        ];
    return list;
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
