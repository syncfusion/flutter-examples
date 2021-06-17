/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the stepline chart with inversed logarithmic axis sample.
class LogarithmicAxisInversed extends SampleView {
  /// Creates the stepline chart with inversed logarithmic axis sample.
  const LogarithmicAxisInversed(Key key) : super(key: key);

  @override
  _LogarithmicAxisInversedState createState() =>
      _LogarithmicAxisInversedState();
}

/// State class of the stepline cahrt with inversed logarithmic axis sample.
class _LogarithmicAxisInversedState extends SampleViewState {
  _LogarithmicAxisInversedState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true, format: 'point.y', header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildInversedLogarithmicAxisChart();
  }

  /// Returns the stepline chart with inversed logarithmic axis.
  SfCartesianChart _buildInversedLogarithmicAxisChart() {
    String text;
    return SfCartesianChart(
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        text = format
            .format(args.dataPoints![args.pointIndex!.toInt()].y)
            .toString();
        args.text = text;
      },
      axisLabelFormatter: (AxisLabelRenderDetails details) {
        final NumberFormat format = NumberFormat.decimalPattern();
        return ChartAxisLabel(
            details.axisName == 'primaryYAxis'
                ? format.format(double.parse(details.text)).toString()
                : details.text,
            null);
      },
      plotAreaBorderWidth: 0,
      title:
          ChartTitle(text: isCardView ? '' : 'Population of various countries'),
      primaryXAxis: CategoryAxis(
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.hide
            : AxisLabelIntersectAction.none,
        labelRotation: isCardView ? 0 : -45,
      ),
      primaryYAxis: LogarithmicAxis(
        minorTicksPerInterval: 5,
        majorGridLines: const MajorGridLines(width: 1.5),
        minorTickLines: const MinorTickLines(size: 4),
        isInversed: true,
        interval: 1,
      ),
      series: _getInversedLogarithmicSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series
  /// which need to render on the stepline chart.
  List<ChartSeries<ChartSampleData, String>> _getInversedLogarithmicSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'China', yValue: 1433783686),
      ChartSampleData(x: 'India', yValue: 1366417754),
      ChartSampleData(x: 'US', yValue: 329064917),
      ChartSampleData(x: 'Japan', yValue: 126860301),
      ChartSampleData(x: 'UK', yValue: 67530172),
      ChartSampleData(x: 'Canada', yValue: 37411047),
      ChartSampleData(x: 'Greece', yValue: 10473455),
      ChartSampleData(x: 'Maldives', yValue: 530953),
      ChartSampleData(x: 'Dominica', yValue: 71808),
    ];
    return <ChartSeries<ChartSampleData, String>>[
      StepLineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          markerSettings: const MarkerSettings(
              isVisible: true,
              width: 5,
              height: 5,
              shape: DataMarkerType.rectangle))
    ];
  }
}
