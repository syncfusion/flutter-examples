/// Package import.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the pie series chart with segments having varying radii based on data values.
class PieRadius extends SampleView {
  /// Creates the pie series chart with segments having varying radii based on data values.
  const PieRadius(Key key) : super(key: key);

  @override
  _PieRadiusState createState() => _PieRadiusState();
}

/// State class for the pie series chart with segments having varying radii.
class _PieRadiusState extends SampleViewState {
  _PieRadiusState();
  late TooltipBehavior _tooltipBehavior;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Argentina', y: 505370, text: '45%'),
      ChartSampleData(x: 'Belgium', y: 551500, text: '53.7%'),
      ChartSampleData(x: 'Cuba', y: 312685, text: '59.6%'),
      ChartSampleData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
      ChartSampleData(x: 'Egypt', y: 301000, text: '85.8%'),
      ChartSampleData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
      ChartSampleData(x: 'Somalia', y: 357022, text: '95.6%'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadiusPieChart();
  }

  /// Returns a circular pie chart with segments of varying radii.
  SfCircularChart _buildRadiusPieChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Various countries population density and area',
      ),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: _buildPieSeries(),
      onTooltipRender: (TooltipArgs args) {
        final NumberFormat format = NumberFormat.decimalPattern();
        args.text =
            args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            format.format(args.dataPoints![args.pointIndex!.toInt()].y);
      },
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
