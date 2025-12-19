/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Render the semi pie series.
class SemiPieChart extends SampleView {
  /// Creates the semi pie series.
  const SemiPieChart(Key key) : super(key: key);

  @override
  _SemiPieChartState createState() => _SemiPieChartState();
}

/// State class for the semi pie series.
class _SemiPieChartState extends SampleViewState {
  _SemiPieChartState();
  late int _startAngle;
  late int _endAngle;
  late List<ChartSampleData> _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _startAngle = 270;
    _endAngle = 90;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Algeria', y: 28),
      ChartSampleData(x: 'Australia', y: 14),
      ChartSampleData(x: 'Bolivia', y: 31),
      ChartSampleData(x: 'Cambodia', y: 77),
      ChartSampleData(x: 'Canada', y: 19),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[_buildStartAngleSetting(), _buildEndAngleSetting()],
    );
  }

  /// Creates a UI component for adjusting the starting angle of the chart.
  Widget _buildStartAngleSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Start angle',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        CustomDirectionalButtons(
          minValue: 90,
          maxValue: 270,
          initialValue: _startAngle.toDouble(),
          onChanged: (double val) => setState(() {
            _startAngle = val.toInt();
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
      ],
    );
  }

  /// Creates a UI component for adjusting the ending angle of the chart.
  Widget _buildEndAngleSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'End angle',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        CustomDirectionalButtons(
          minValue: 90,
          maxValue: 270,
          initialValue: _endAngle.toDouble(),
          onChanged: (double val) => setState(() {
            _endAngle = val.toInt();
          }),
          step: 10,
          iconColor: model.textColor,
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSemiPieChartChart();
  }

  /// Returns the circular chart with semi pie series.
  SfCircularChart _buildSemiPieChartChart() {
    return SfCircularChart(
      centerY: '60%',
      title: ChartTitle(
        text: isCardView ? '' : 'Rural population of various countries',
      ),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: _buildPieSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the semi pie series.
  List<PieSeries<ChartSampleData, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.x,

        /// If we set start and end angle given below
        /// it will render as semi pie chart.
        startAngle: _startAngle,
        endAngle: _endAngle,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
