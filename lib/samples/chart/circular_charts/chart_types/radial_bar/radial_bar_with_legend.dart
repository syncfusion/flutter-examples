/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the radial series with legend.
class RadialBarAngle extends SampleView {
  /// Creates the radial series with legend.
  const RadialBarAngle(Key key) : super(key: key);

  @override
  _RadialBarAngleState createState() => _RadialBarAngleState();
}

/// State class of radial series with legend.
class _RadialBarAngleState extends SampleViewState {
  _RadialBarAngleState();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAngleRadialBarChart();
  }

  /// Retunrs the circular charts with radial series.
  SfCircularChart _buildAngleRadialBarChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Activity tracker'),

      /// To enable the legend for radial bar.
      legend: Legend(
          isVisible: true,
          iconHeight: 20,
          iconWidth: 20,
          overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,
      series: _getRadialBarSeries(),
    );
  }

  /// Returns radial bar series with legend.
  List<RadialBarSeries<ChartSampleData, String>> _getRadialBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Move 65%\n338/520 CAL',
          y: 65,
          text: 'Move  ',
          xValue: null,
          pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
      ChartSampleData(
          x: 'Exercise 43%\n13/30 MIN',
          y: 43,
          text: 'Exercise  ',
          xValue: null,
          pointColor: const Color.fromRGBO(63, 224, 0, 1.0)),
      ChartSampleData(
          x: 'Stand 58%\n7/12 HR',
          y: 58,
          text: 'Stand  ',
          xValue: null,
          pointColor: const Color.fromRGBO(226, 1, 26, 1.0)),
    ];
    final List<RadialBarSeries<ChartSampleData, String>> list =
        <RadialBarSeries<ChartSampleData, String>>[
      RadialBarSeries<ChartSampleData, String>(
          animationDuration: 0,
          // pointRadiusMapper: (ChartSampleData data, _) => data.xValue as String,
          maximumValue: 100,
          radius: '100%',
          gap: '2%',
          innerRadius: '30%',
          dataSource: chartData,
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: DataLabelSettings(isVisible: true))
    ];
    return list;
  }
}
