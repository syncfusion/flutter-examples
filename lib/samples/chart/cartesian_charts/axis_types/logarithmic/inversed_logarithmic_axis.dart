/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the StepLine Chart with inversed logarithmic axis sample.
class LogarithmicAxisInversed extends SampleView {
  const LogarithmicAxisInversed(Key key) : super(key: key);

  @override
  _LogarithmicAxisInversedState createState() =>
      _LogarithmicAxisInversedState();
}

/// State class of the StepLine Chart with inversed logarithmic axis sample.
class _LogarithmicAxisInversedState extends SampleViewState {
  _LogarithmicAxisInversedState();

  List<ChartSampleData>? _countriesPopulationData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _countriesPopulationData = <ChartSampleData>[
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
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.y',
      header: '',
      canShowMarker: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with StepLine series.
  SfCartesianChart _buildCartesianChart() {
    String text;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Population of various countries',
      ),
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
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          final NumberFormat format = NumberFormat.decimalPattern();
          return ChartAxisLabel(
            format.format(double.parse(details.text)),
            null,
          );
        },
      ),
      series: _buildStepLineSeries(),
      tooltipBehavior: _tooltipBehavior,
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        text = format.format(args.dataPoints![args.pointIndex!.toInt()].y);
        args.text = text;
      },
    );
  }

  /// Returns the list of Cartesian StepLine series.
  List<CartesianSeries<ChartSampleData, String>> _buildStepLineSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      StepLineSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'China', yValue: 1433783686),
          ChartSampleData(x: 'India', yValue: 1366417754),
          ChartSampleData(x: 'US', yValue: 329064917),
          ChartSampleData(x: 'Japan', yValue: 126860301),
          ChartSampleData(x: 'UK', yValue: 67530172),
          ChartSampleData(x: 'Canada', yValue: 37411047),
          ChartSampleData(x: 'Greece', yValue: 10473455),
          ChartSampleData(x: 'Maldives', yValue: 530953),
          ChartSampleData(x: 'Dominica', yValue: 71808),
        ],
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        markerSettings: const MarkerSettings(
          isVisible: true,
          width: 5,
          height: 5,
          shape: DataMarkerType.rectangle,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _countriesPopulationData!.clear();
    super.dispose();
  }
}
