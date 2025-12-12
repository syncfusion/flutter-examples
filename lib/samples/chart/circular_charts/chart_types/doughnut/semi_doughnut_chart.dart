/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';
import '../../../../../widgets/custom_button.dart';

/// Renders the semi doughnut series chart.
class SemiDoughnutChart extends SampleView {
  /// Creates the semi doughnut series chart.
  const SemiDoughnutChart(Key key) : super(key: key);

  @override
  _SemiDoughnutChartState createState() => _SemiDoughnutChartState();
}

/// State class for the semi doughnut series chart.
class _SemiDoughnutChartState extends SampleViewState {
  _SemiDoughnutChartState();
  late int _startAngle;
  late int _endAngle;
  late List<ChartSampleData> _chartData;

  @override
  void initState() {
    _startAngle = 270;
    _endAngle = 90;
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 45, text: 'David 45%'),
      ChartSampleData(x: 'Steve', y: 15, text: 'Steve 15%'),
      ChartSampleData(x: 'Jack', y: 21, text: 'Jack 21%'),
      ChartSampleData(x: 'Others', y: 19, text: 'Others 19%'),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    // Build a settings view containing angle adjustment controls.
    return ListView(
      shrinkWrap: true,
      children: <Widget>[_buildStartAngleSetting(), _buildEndAngleSetting()],
    );
  }

  /// Builds the start angle adjustment setting.
  Widget _buildStartAngleSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Start angle  ',
          style: TextStyle(fontSize: 16.0, color: model.textColor),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: CustomDirectionalButtons(
            minValue: 90,
            maxValue: 270,
            initialValue: _startAngle.toDouble(),
            onChanged: (double val) => setState(() {
              _startAngle = val.toInt();
            }),
            step: 10,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  /// Builds the end angle adjustment setting.
  Widget _buildEndAngleSetting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            'End angle ',
            style: TextStyle(fontSize: 16.0, color: model.textColor),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: CustomDirectionalButtons(
            minValue: 90,
            maxValue: 270,
            initialValue: _endAngle.toDouble(),
            onChanged: (double val) => setState(() {
              _endAngle = val.toInt();
            }),
            step: 10,
            iconColor: model.textColor,
            style: TextStyle(fontSize: 20.0, color: model.textColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSemiDoughnutChart();
  }

  /// Returns a circular semi doughnut chart.
  SfCircularChart _buildSemiDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      centerY: isCardView ? '65%' : '60%',
      series: _buildSemiDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the circular semi doughnut series.
  List<DoughnutSeries<ChartSampleData, String>> _buildSemiDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        innerRadius: '70%',
        radius: isCardView ? '100%' : '59%',
        startAngle: _startAngle,
        endAngle: _endAngle,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
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
